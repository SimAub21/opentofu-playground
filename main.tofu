terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
    }
  }
}

provider "xenorchestra" {
  url      = var.xo_url
  username = var.xo_user
  password = var.xo_password
  insecure = true
}

# Datenquellen abrufen
data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}

data "xenorchestra_template" "ubuntu_template" {
  name_label = var.template_name
}

data "xenorchestra_network" "testnet" {
  name_label = var.network_name
}

data "xenorchestra_sr" "storage" {
  name_label = var.storage_name
}

# Cloud-Init Konfiguration aus externer Datei laden
resource "xenorchestra_cloud_config" "ubuntu_config" {
  count = 3
  name = "ubuntu-cloud-init"
  template = templatefile("${path.module}/cloud_config.yaml", {
    vm_hostname = "${var.vm_hostname}-${count.index + 1}"
    username = var.vm_user
    ssh_keys = [for p in var.ssh_public_key_paths : trimspace(file(pathexpand(p)))]
  })
}

# Die 3 Virtual Machines erstellen
resource "xenorchestra_vm" "ubuntu_vms" {
  count      = 3
  name_label = "${var.vm_hostname}-${count.index + 1}"
  template   = data.xenorchestra_template.ubuntu_template.id

  hvm_boot_firmware = "uefi"  
  cpus       = 2
  memory_max = var.vm_memory_gb * 1024 * 1024 * 1024
  
  network {
    network_id = data.xenorchestra_network.testnet.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.storage.id
    name_label = "${var.vm_hostname}-${count.index + 1}-os-disk"
    size       = var.vm_disk_gb * 1024 * 1024 * 1024
  }

  disk {
    sr_id      = data.xenorchestra_sr.storage.id
    name_label = "ubuntu-node-${count.index + 1}-ceph-disk"
    size       = 5 * 1024 * 1024 * 1024
  }

  cloud_config = xenorchestra_cloud_config.ubuntu_config[count.index].template
}

# Ausgabe der IP-Adressen für Ansible
output "instance_ips" {
  value = {
    for vm in xenorchestra_vm.ubuntu_vms :
    vm.name_label => vm.ipv4_addresses[0]
  }
  description = "Mapping von VM-Namen zu ihren IP-Adressen"
}