provider "proxmox" {
  endpoint  = "https://10.20.7.17:8006"
  api_token = var.pve_api_token
  insecure  = true

  ssh {
    username    = "root"
    private_key = file("~/.ssh/id_rsa")

    node {
      name    = "fichina"
      address = "10.20.7.11"
    }
    node {
      name    = "macbeth"
      address = "10.20.7.12"
    }
    node {
      name    = "titania"
      address = "10.20.7.13"
    }
    node {
      name    = "zoness"
      address = "10.20.7.14"
    }
    node {
      name    = "fortuna"
      address = "10.20.7.15"
    }
    node {
      name    = "eldarad"
      address = "10.20.7.16"
    }
    node {
      name    = "venom"
      address = "10.20.7.17"
    }

  }
}

