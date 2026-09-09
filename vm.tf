resource "proxmox_virtual_environment_vm" "this" {
  depends_on = [proxmox_virtual_environment_file.cloud_init]
  for_each   = local.expanded_vms

  name            = each.value.name
  description     = each.value.description
  tags            = each.value.tags
  template        = each.value.template
  started         = each.value.started
  keyboard_layout = each.value.keyboard_layout
  migrate         = each.value.migrate
  on_boot         = each.value.on_boot
  reboot          = each.value.reboot
  stop_on_destroy = each.value.stop_on_destroy

  node_name = each.value.node_name
  vm_id     = each.value.vm_id

  agent {
    enabled = each.value.agent_enabled
  }

  boot_order = each.value.boot_order

  disk {
    datastore_id = each.value.disk.datastore_id
    interface    = each.value.disk.interface
    file_id      = each.value.image_key == null ? null : local.image_file_ids[each.value.image_key]
    import_from  = try(each.value.disk.import_from, null)
    iothread     = each.value.disk.iothread
    size         = each.value.disk.size
  }

  dynamic "initialization" {
    for_each = each.value.initialization == null ? [] : [each.value.initialization]
    content {
      interface         = initialization.value.interface
      datastore_id      = initialization.value.datastore_id
      upgrade           = initialization.value.upgrade
      user_data_file_id = initialization.value.cloud_init_key == null ? null : local.cloud_init_file_ids[initialization.value.cloud_init_key]

      dynamic "dns" {
        for_each = initialization.value.dns == null ? [] : [initialization.value.dns]
        content {
          domain  = dns.value.domain
          servers = dns.value.servers
        }
      }

      dynamic "ip_config" {
        for_each = initialization.value.ip_configs
        content {
          dynamic "ipv4" {
            for_each = ip_config.value.ipv4 == null ? [] : [ip_config.value.ipv4]
            content {
              address = ipv4.value.address
              gateway = ipv4.value.gateway
            }
          }
        }
      }

      dynamic "user_account" {
        for_each = initialization.value.user_account == null ? [] : [initialization.value.user_account]
        content {
          username = user_account.value.username
          keys     = length(user_account.value.keys) > 0 ? user_account.value.keys : [trimspace(data.local_file.ssh_public_key.content)]
        }
      }
    }
  }

  dynamic "network_device" {
    for_each = each.value.network_devices
    content {
      disconnected = network_device.value.disconnected
      bridge       = network_device.value.bridge
      model        = network_device.value.model
      vlan_id      = network_device.value.vlan_id
    }
  }

  dynamic "serial_device" {
    for_each = each.value.serial_devices
    content {
      device = serial_device.value.device
    }
  }

  cpu {
    cores      = each.value.cpu.cores
    flags      = each.value.cpu.flags
    hotplugged = each.value.cpu.hotplugged
    limit      = each.value.cpu.limit
    numa       = each.value.cpu.numa
    sockets    = each.value.cpu.sockets
    type       = each.value.cpu.type
    units      = each.value.cpu.units
  }

  memory {
    dedicated      = each.value.memory.dedicated
    floating       = each.value.memory.floating
    keep_hugepages = each.value.memory.keep_hugepages
    shared         = each.value.memory.shared
  }

  operating_system {
    type = each.value.operating_system_type
  }

  dynamic "vga" {
    for_each = each.value.vga == null ? [] : [each.value.vga]
    content {
      memory = vga.value.memory
      type   = vga.value.type
    }
  }

  timeout_clone       = each.value.timeouts.clone
  timeout_create      = each.value.timeouts.create
  timeout_migrate     = each.value.timeouts.migrate
  timeout_reboot      = each.value.timeouts.reboot
  timeout_shutdown_vm = each.value.timeouts.shutdown_vm
  timeout_start_vm    = each.value.timeouts.start_vm
  timeout_stop_vm     = each.value.timeouts.stop_vm

  lifecycle {
    ignore_changes = [
      initialization[0].user_account,
    ]

    precondition {
      condition     = each.value.vm_id > 0
      error_message = "VM IDs must be positive."
    }

    precondition {
      condition     = each.value.image_key == null || contains(keys(var.download_files), each.value.image_key)
      error_message = "Each image_key must exist in var.download_files."
    }

    precondition {
      condition     = each.value.initialization == null || each.value.initialization.cloud_init_key == null || contains(keys(local.all_cloud_init_files), each.value.initialization.cloud_init_key)
      error_message = "Each cloud_init_key must exist in nested standalone VM cloud-init or generated per-node group cloud-init snippets."
    }

    precondition {
      condition     = each.value.disk.size > 0
      error_message = "Disk size must be positive."
    }

    precondition {
      condition     = each.value.memory.dedicated > 0
      error_message = "Dedicated memory must be positive."
    }
  }
}
