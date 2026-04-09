# OpenTofu collection

## Create variables file:

Create a **terraform.tfvars** file with this structure:

```bash
# Verbindung zu XO
xo_url      = "ws://10.200.200.100"
xo_user     = "username" # TODO: replace with real values
xo_password = "password"

# Infrastruktur Namen (aus deinem XO)
pool_name     = "xcp-ng-prod"
template_name = "Ubuntu 24.04 Cloud-Init (Hub)"
network_name  = "testnet"
storage_name  = "Local storage"

# User Setup
vm_user        = "user"
ssh_public_key_paths = [
  "~/.ssh/id_ed25519.pub"
]

# Ressourcen
vm_memory_gb = 0.5
vm_disk_gb   = 10
```

Because it might contain sensitive data it should be not checked in in git.

## Run tofu "playbook":

1. Init OpenTofu project, e.g. load provider
```bash
tofu init
```

2. Here you can see what will be changed and if there is a connection

```bash
tofu plan
```

3. Apply and execute the script
```bash
tofu apply
```

## 🐧 Ubuntu VM Template Preparation for XCP-ng

Download ubuntu server iso file and create a vm. Start the vm and type in the follow the steps described below.

### Install Guest-Utilities & Cloud-Init

1. Xen Guest Utilities
Since the xen guest tools are not working with apt package xe-guest-utilities, we can also the Guest-Tools iso file and install it.

```bash
sudo mount /dev/cdrom /mnt
cd /mnt/Linux
sudo ./install.sh
```

3. Run system updates

```bash
sudo apt update && apt upgrade -y
```

4. Cloud-Init

```bash
sudo apt install cloud-init -y
```

5. Clean package cache
```bash
sudo apt clean && sudo apt autoremove -y
```
6. Reset Machine-ID
This ensures that clone has a unique machine id

```bash
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
```

7. Cloud-Init Logs clean

```bash
sudo cloud-init clean --logs
```

8. Clear command history and shutdown vm

```bash
history -c && history -w && sudo shutdown now
```

9. Convert VM to template
In XOA go to advanced tab and click convert to template button. 