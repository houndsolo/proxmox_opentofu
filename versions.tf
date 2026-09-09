terraform {
  required_providers {
    proxmox = {
      source  = "local/mechanic/proxmox"
      version = "0.111.0"
    }

    local = {
      source = "hashicorp/local"
    }
  }
}
