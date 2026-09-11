variable "default_ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

locals {
  default_ssh_public_key = trimspace(file(pathexpand("~/.ssh/id_rsa.pub")))

  lxc_user_account_keys = {
    for lxc_key, lxc in var.lxcs :
    lxc_key => length(try(lxc.initialization.user_account.keys, [])) > 0 ? lxc.initialization.user_account.keys : [
      local.default_ssh_public_key
    ]
    if try(lxc.initialization.user_account, null) != null
  }
}
variable "pve_nodes" {
  description = "Known Proxmox node ID metadata keyed by node name. Prefer proxmox_node_ids for VM group ID/suffix lookups."
  type = map(object({
    id   = number
    cpus = number
  }))
}

variable "pve_network" {
  description = "Proxmox cluster networking configuration"

  type = object({
    bonds = map(object({
      mtu                   = number
      slaves                = list(string)
      bond_mode             = string
      bond_xmit_hash_policy = string
      description           = optional(string)
    }))
    eths = map(object({
      mtu         = number
      description = string
    }))

    bridges = map(object({
      mtu         = number
      description = string
      vlan_aware  = optional(bool)
      gateway     = optional(string)
      ports       = optional(list(string))

      ipv4 = optional(object({
        cidrhost_prefix = string
        cidr            = number
      }))
    }))

    vlans = map(object({
      port        = string
      mtu         = number
      description = string
      gateway     = optional(string)

      ipv4 = optional(object({
        cidrhost_prefix = string
        cidr            = number
      }))
    }))
  })
}

variable "dns" {
  description = "DNS configuration"
  type = object({
    name_servers  = list(string)
    domain_name   = string
    domain_search = list(string)
  })
}

variable "download_files" {
  description = "Reusable Proxmox downloads, keyed by image_key."
  type = map(object({
    content_type        = string
    datastore_id        = string
    node_name           = string
    url                 = string
    file_name           = optional(string)
    overwrite_unmanaged = optional(bool, true)
    overwrite           = optional(bool)
  }))
}

variable "vms" {
  description = "Explicit VM definitions keyed by a stable logical name."
  type = map(object({
    name            = string
    description     = optional(string, "managed by opentofu")
    tags            = optional(list(string), ["opentofu"])
    template        = optional(bool, false)
    started         = optional(bool, true)
    machine         = optional(string)
    bios            = optional(string)
    keyboard_layout = optional(string, "en-us")
    migrate         = optional(bool, false)
    on_boot         = optional(bool, false)
    reboot          = optional(bool, false)
    stop_on_destroy = optional(bool, true)

    node_name = string
    vm_id     = number

    agent_enabled = optional(bool, true)
    boot_order    = optional(list(string), ["virtio0"])
    image_key     = optional(string)

    cloud_init = optional(object({
      enabled        = optional(bool, true)
      content_type   = optional(string, "snippets")
      datastore_id   = string
      node_name      = string
      file_name      = string
      timezone       = optional(string, "America/New_York")
      hostname       = string
      username       = optional(string, "mechanic")
      groups         = optional(list(string), ["sudo"])
      shell          = optional(string, "/bin/bash")
      sudo           = optional(string, "ALL=(ALL) NOPASSWD:ALL")
      package_update = optional(bool, true)
      packages       = optional(list(string), [])
      runcmd         = optional(list(string), [])
    }))

    disk = object({
      datastore_id = optional(string, "ceph_rbd")
      interface    = string
      import_from  = optional(string)
      iothread     = optional(bool, true)
      size         = number
    })

    initialization = optional(object({
      interface    = optional(string, "scsi0")
      datastore_id = optional(string, "ceph_rbd")
      upgrade      = bool
      dns = optional(object({
        domain  = optional(string)
        servers = list(string)
      }))
      ip_configs = optional(list(object({
        ipv4 = optional(object({
          address = string
          gateway = optional(string)
        }))
      })), [])
      user_account = optional(object({
        username = string
        keys     = optional(list(string), [])
      }))
    }))

    network_devices = optional(list(object({
      disconnected = optional(bool, false)
      bridge       = string
      model        = optional(string, "virtio")
      vlan_id      = optional(string, null)
    })), [])

    serial_devices = optional(list(object({
      device = string
    })), [{ device = "socket" }])

    cpu = object({
      cores      = number
      flags      = optional(list(string), [])
      hotplugged = optional(number, 0)
      limit      = optional(number, 0)
      numa       = optional(bool, false)
      sockets    = optional(number, 1)
      type       = optional(string, "x86-64-v2-AES")
      units      = optional(number, 1024)
    })

    memory = object({
      dedicated      = number
      floating       = optional(number, 0)
      keep_hugepages = optional(bool, false)
      shared         = optional(number, 0)
    })

    operating_system_type = optional(string, "l26")

    vga = optional(object({
      memory = optional(number, 16)
      type   = optional(string, "std")
    }))

    timeouts = optional(object({
      clone       = optional(number, 1800)
      create      = optional(number, 1800)
      migrate     = optional(number, 1800)
      reboot      = optional(number, 1800)
      shutdown_vm = optional(number, 1800)
      start_vm    = optional(number, 1800)
      stop_vm     = optional(number, 300)
    }), {})
  }))

  validation {
    condition     = alltrue([for vm in values(var.vms) : vm.machine == null ? true : contains(["pc", "q35"], vm.machine)])
    error_message = "Machine must be pc or q35 when specified."
  }

  validation {
    condition     = alltrue([for vm in values(var.vms) : vm.bios == null ? true : contains(["seabios", "ovmf"], vm.bios)])
    error_message = "BIOS must be seabios or ovmf (UEFI) when specified."
  }

  validation {
    condition     = alltrue([for vm in values(var.vms) : vm.vm_id > 0])
    error_message = "All explicit VM IDs must be positive."
  }

  validation {
    condition     = alltrue([for vm in values(var.vms) : vm.disk.size > 0])
    error_message = "All explicit VM disk sizes must be positive."
  }

  validation {
    condition     = alltrue([for vm in values(var.vms) : vm.memory.dedicated > 0])
    error_message = "All explicit VM dedicated memory values must be positive."
  }
}

variable "vm_groups" {
  description = "Repeated VM patterns expanded into concrete VM definitions."
  type = map(object({
    enabled     = optional(bool, true)
    machine     = optional(string)
    bios        = optional(string)
    name_prefix = string
    vm_id_base  = number
    image_key   = string
    tags        = optional(list(string), ["opentofu"])
    description = optional(string, "managed by opentofu")
    started     = optional(bool, true)
    template    = optional(bool, false)
    on_boot     = optional(bool, true)
    cloud_init = object({
      enabled           = optional(bool, true)
      mode              = optional(string, "per_node")
      content_type      = optional(string, "snippets")
      datastore_id      = string
      node_name         = string
      file_name_pattern = string
      hostname_pattern  = string
      timezone          = optional(string, "America/New_York")
      username          = optional(string, "mechanic")
      groups            = optional(list(string), ["sudo"])
      shell             = optional(string, "/bin/bash")
      sudo              = optional(string, "ALL=(ALL) NOPASSWD:ALL")
      package_update    = optional(bool, true)
      packages          = optional(list(string), [])
      runcmd            = optional(list(string), [])
    })
    disk = object({
      datastore_id = optional(string, "ceph_rbd")
      interface    = string
      size         = number
      iothread     = optional(bool, true)
    })
    initialization = object({
      datastore_id = optional(string, "ceph_rbd")
      interface    = optional(string, "scsi0")
      upgrade      = bool
      dns = optional(object({
        domain  = optional(string)
        servers = list(string)
      }))
      user_account = optional(object({
        username = string
        keys     = optional(list(string), [])
      }))
    })
    networks = list(object({
      disconnected = optional(bool, false)
      bridge       = string
      model        = optional(string, "virtio")
      vlan_id      = optional(string)
    }))
    ip_configs = list(object({
      ipv4_address_template = string
      gateway               = optional(string)
    }))
    cpu = object({
      cores      = number
      flags      = optional(list(string), [])
      hotplugged = optional(number, 0)
      limit      = optional(number, 0)
      numa       = optional(bool, false)
      sockets    = optional(number, 1)
      type       = optional(string, "x86-64-v2-AES")
      units      = optional(number, 1024)
    })
    memory = object({
      dedicated      = number
      floating       = optional(number, 0)
      keep_hugepages = optional(bool, false)
      shared         = optional(number, 0)
    })
    operating_system_type = optional(string, "l26")
    vga = optional(object({
      memory = optional(number, 16)
      type   = optional(string, "serial0")
    }))
    serial_devices = optional(list(object({
      device = string
    })), [{ device = "socket" }])
  }))

  validation {
    condition     = alltrue([for group in values(var.vm_groups) : group.machine == null ? true : contains(["pc", "q35"], group.machine)])
    error_message = "Machine must be pc or q35 when specified."
  }

  validation {
    condition     = alltrue([for group in values(var.vm_groups) : group.bios == null ? true : contains(["seabios", "ovmf"], group.bios)])
    error_message = "BIOS must be seabios or ovmf (UEFI) when specified."
  }

  validation {
    condition     = alltrue([for group in values(var.vm_groups) : group.vm_id_base > 0])
    error_message = "All VM group base IDs must be positive."
  }

  validation {
    condition     = alltrue([for group in values(var.vm_groups) : group.disk.size > 0])
    error_message = "All VM group disk sizes must be positive."
  }

  validation {
    condition     = alltrue([for group in values(var.vm_groups) : group.memory.dedicated > 0])
    error_message = "All VM group dedicated memory values must be positive."
  }
}

variable "lxcs" {
  description = "Explicit LXC container definitions keyed by a stable logical name."
  type = map(object({
    description   = optional(string, "managed by opentofu")
    node_name     = string
    vm_id         = number
    started       = optional(bool, true)
    start_on_boot = optional(bool, true)
    tags          = optional(list(string), ["opentofu", "lxc"])
    template      = optional(bool, false)
    unprivileged  = optional(bool, true)
    protection    = optional(bool, false)
    wait_for_ip = optional(object({
      ipv4 = optional(bool, false)
      ipv6 = optional(bool, false)
    }))

    image_key        = optional(string)
    template_file_id = optional(string)

    features = optional(object({
      nesting = optional(bool, true)
      fuse    = optional(bool, false)
      keyctl  = optional(bool, false)
      mount   = optional(list(string), [])
      mknod   = optional(bool, false)
    }))

    initialization = object({
      hostname = string
      dns = optional(object({
        domain  = optional(string)
        servers = list(string)
      }))
      ip_configs = optional(list(object({
        ipv4 = optional(object({
          address = string
          gateway = optional(string)
        }))
        ipv6 = optional(object({
          address = string
          gateway = optional(string)
        }))
      })), [])
      user_account = optional(object({
        keys     = optional(list(string), [])
        password = optional(string)
      }))
    })

    network_interfaces = optional(list(object({
      name        = string
      bridge      = optional(string, "vmbr0")
      enabled     = optional(bool, true)
      firewall    = optional(bool, false)
      mac_address = optional(string)
      mtu         = optional(number)
      rate_limit  = optional(number)
      vlan_id     = optional(number)
    })), [])

    disk = object({
      datastore_id  = optional(string, "ceph_rbd")
      size          = optional(number, 4)
      mount_options = optional(list(string), [])
    })

    mount_points = optional(list(object({
      volume        = string
      path          = string
      size          = optional(string)
      acl           = optional(bool)
      backup        = optional(bool, false)
      mount_options = optional(list(string), [])
      quota         = optional(bool)
      read_only     = optional(bool)
      replicate     = optional(bool)
      shared        = optional(bool)
    })), [])

    operating_system = optional(object({
      template_file_id = string
      type             = string
    }))

    cpu = optional(object({
      architecture = optional(string, "amd64")
      cores        = optional(number, 1)
      limit        = optional(number, 0)
      units        = optional(number, 1024)
    }), {})

    memory = optional(object({
      dedicated = optional(number, 512)
      swap      = optional(number, 0)
    }), {})

    startup = optional(object({
      order      = number
      up_delay   = optional(number)
      down_delay = optional(number)
    }))

    timeouts = optional(object({
      clone  = optional(number, 1800)
      create = optional(number, 1800)
      delete = optional(number, 60)
      update = optional(number, 1800)
    }), {})
  }))

  default = {}

  validation {
    condition     = alltrue([for lxc in values(var.lxcs) : lxc.vm_id > 0])
    error_message = "All LXC IDs must be positive."
  }

  validation {
    condition     = alltrue([for lxc in values(var.lxcs) : lxc.disk.size >= 0])
    error_message = "All LXC disk sizes must be zero or positive."
  }

  validation {
    condition     = alltrue([for lxc in values(var.lxcs) : lxc.memory.dedicated > 0])
    error_message = "All LXC dedicated memory values must be positive."
  }
}
