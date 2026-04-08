# OpenTofu collection

## Create variables file:

Create a **terraform.tfvars** file with this structure:

```bash
# Verbindung zu XO
xo_url      = "ws://10.200.200.1"
xo_user     = "username" # TODO: replace with real values or env file
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