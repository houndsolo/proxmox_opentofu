resource "proxmox_virtual_environment_container" "this" {
  depends_on = [module.proxmox_download_files]
  for_each   = var.lxcs

  description   = each.value.description
  node_name     = each.value.node_name
  vm_id         = each.value.vm_id
  started       = each.value.started
  start_on_boot = each.value.start_on_boot
  tags          = each.value.tags
  template      = each.value.template
  unprivileged  = each.value.unprivileged
  protection    = each.value.protection

  dynamic "wait_for_ip" {
    for_each = each.value.wait_for_ip == null ? [] : [each.value.wait_for_ip]
    content {
      ipv4 = wait_for_ip.value.ipv4
      ipv6 = wait_for_ip.value.ipv6
    }
  }

  dynamic "features" {
    for_each = each.value.features == null ? [] : [each.value.features]
    content {
      nesting = features.value.nesting
      fuse    = features.value.fuse
      keyctl  = features.value.keyctl
      mount   = features.value.mount
      mknod   = features.value.mknod
    }
  }

  initialization {
    hostname = each.value.initialization.hostname

    dynamic "dns" {
      for_each = each.value.initialization.dns == null ? [] : [each.value.initialization.dns]
      content {
        domain  = dns.value.domain
        servers = dns.value.servers
      }
    }

    dynamic "ip_config" {
      for_each = each.value.initialization.ip_configs
      content {
        dynamic "ipv4" {
          for_each = ip_config.value.ipv4 == null ? [] : [ip_config.value.ipv4]
          content {
            address = ipv4.value.address
            gateway = ipv4.value.gateway
          }
        }

        dynamic "ipv6" {
          for_each = ip_config.value.ipv6 == null ? [] : [ip_config.value.ipv6]
          content {
            address = ipv6.value.address
            gateway = ipv6.value.gateway
          }
        }
      }
    }
    dynamic "user_account" {
      for_each = try(each.value.initialization.user_account, null) == null ? [] : [
        each.value.initialization.user_account
      ]

      content {
        keys = length(try(user_account.value.keys, [])) > 0 ? user_account.value.keys : [
          local.default_ssh_public_key
        ]

        password = try(user_account.value.password, null)
      }
    }

  }

  dynamic "network_interface" {
    for_each = each.value.network_interfaces
    content {
      name        = network_interface.value.name
      bridge      = network_interface.value.bridge
      enabled     = network_interface.value.enabled
      firewall    = network_interface.value.firewall
      mac_address = network_interface.value.mac_address
      mtu         = network_interface.value.mtu
      rate_limit  = network_interface.value.rate_limit
      vlan_id     = network_interface.value.vlan_id
    }
  }

  disk {
    datastore_id  = each.value.disk.datastore_id
    size          = each.value.disk.size
    mount_options = each.value.disk.mount_options
  }

  dynamic "mount_point" {
    for_each = each.value.mount_points
    content {
      volume        = mount_point.value.volume
      path          = mount_point.value.path
      size          = mount_point.value.size
      acl           = mount_point.value.acl
      backup        = mount_point.value.backup
      mount_options = mount_point.value.mount_options
      quota         = mount_point.value.quota
      read_only     = mount_point.value.read_only
      replicate     = mount_point.value.replicate
      shared        = mount_point.value.shared
    }
  }

  operating_system {
    template_file_id = each.value.operating_system.template_file_id == null ? local.image_file_ids[each.value.image_key] : each.value.operating_system.template_file_id
    type             = each.value.operating_system.type
  }

  cpu {
    architecture = each.value.cpu.architecture
    cores        = each.value.cpu.cores
    limit        = each.value.cpu.limit
    units        = each.value.cpu.units
  }

  memory {
    dedicated = each.value.memory.dedicated
    swap      = each.value.memory.swap
  }

  dynamic "startup" {
    for_each = each.value.startup == null ? [] : [each.value.startup]
    content {
      order      = startup.value.order
      up_delay   = startup.value.up_delay
      down_delay = startup.value.down_delay
    }
  }

  timeout_create = each.value.timeouts.create
  timeout_clone  = each.value.timeouts.clone
  timeout_delete = each.value.timeouts.delete
  timeout_update = each.value.timeouts.update

  lifecycle {
    precondition {
      condition     = each.value.vm_id > 0
      error_message = "LXC IDs must be positive."
    }

    precondition {
      condition     = each.value.image_key == null || contains(keys(var.download_files), each.value.image_key)
      error_message = "Each LXC image_key must exist in var.download_files."
    }

    precondition {
      condition     = each.value.operating_system.template_file_id != null || each.value.image_key != null
      error_message = "Each LXC must set either template_file_id or image_key."
    }

    precondition {
      condition     = each.value.disk.size >= 0
      error_message = "LXC disk size must be zero or positive."
    }

    precondition {
      condition     = each.value.memory.dedicated > 0
      error_message = "LXC dedicated memory must be positive."
    }
  }
}
