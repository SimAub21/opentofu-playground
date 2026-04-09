variable "xo_url" { type = string }
variable "xo_user" { type = string }
variable "xo_password" { 
    type = string
    sensitive = true 
}

variable "pool_name" { type = string }
variable "template_name" { type = string }
variable "network_name" { type = string }
variable "storage_name" { type = string }

variable "vm_hostname" { type = string }

variable "vm_user" {
    type = string
    default = "user" 
}

variable "ssh_public_key_paths" {
  type    = list(string)
  description = "list of public ssh keys added to the server"
}

variable "vm_memory_gb" {
    type = number
    default = 1
}
variable "vm_disk_gb" {
    type = number
    default = 10
}