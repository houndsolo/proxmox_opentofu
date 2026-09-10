locals {
  image_file_ids = module.proxmox_download_files.file_ids


  proxmox_allnodes = {
    for node_name in data.proxmox_virtual_environment_nodes.available_nodes.names :
    node_name => {
      id = var.pve_nodes[node_name].id
    }
  }

  standalone_vm_cloud_init_files = {
    for vm_key, vm in var.vms : vm_key => {
      content_type   = try(vm.cloud_init.content_type, "snippets")
      datastore_id   = try(vm.cloud_init.datastore_id, null)
      node_name      = try(vm.cloud_init.node_name, null)
      file_name      = try(vm.cloud_init.file_name, null)
      timezone       = try(vm.cloud_init.timezone, "America/New_York")
      hostname       = try(vm.cloud_init.hostname, null)
      username       = try(vm.cloud_init.username, "mechanic")
      groups         = try(vm.cloud_init.groups, ["sudo"])
      shell          = try(vm.cloud_init.shell, "/bin/bash")
      sudo           = try(vm.cloud_init.sudo, "ALL=(ALL) NOPASSWD:ALL")
      package_update = try(vm.cloud_init.package_update, true)
      packages       = try(vm.cloud_init.packages, [])
      runcmd         = try(vm.cloud_init.runcmd, [])
    } if try(vm.cloud_init.enabled, false)
  }

  expanded_group_cloud_init_files = merge(concat([{}], [
    for group_key, group in var.vm_groups : {
      for node_name, node in local.proxmox_allnodes : "${group_key}_${node_name}" => {
        content_type   = group.cloud_init.content_type
        datastore_id   = group.cloud_init.datastore_id
        node_name      = group.cloud_init.node_name
        file_name      = replace(replace(group.cloud_init.file_name_pattern, "{node_name}", node_name), "{node_id}", tostring(node.id))
        timezone       = group.cloud_init.timezone
        hostname       = replace(replace(group.cloud_init.hostname_pattern, "{node_name}", node_name), "{node_id}", tostring(node.id))
        username       = group.cloud_init.username
        groups         = group.cloud_init.groups
        shell          = group.cloud_init.shell
        sudo           = group.cloud_init.sudo
        package_update = group.cloud_init.package_update
        packages       = group.cloud_init.packages
        runcmd         = group.cloud_init.runcmd
      }
    } if group.enabled && try(group.cloud_init.enabled, true) && group.cloud_init.mode == "per_node"
  ])...)

  all_cloud_init_files = merge(local.standalone_vm_cloud_init_files, local.expanded_group_cloud_init_files)

  cloud_init_file_ids = {
    for k, v in proxmox_virtual_environment_file.cloud_init : k => v.id
  }

  standalone_vms = {
    for vm_key, vm in var.vms : vm_key => merge(vm, {
      initialization = vm.initialization == null ? null : merge(vm.initialization, {
        cloud_init_key = try(vm.cloud_init.enabled, false) ? vm_key : null
      })
    })
  }

  expanded_group_vms = merge(concat([{}], [
    for group_key, group in var.vm_groups : {
      for node_name, node in local.proxmox_allnodes : "${group_key}_${node_name}" => {
        name            = "${group.name_prefix}-${node_name}"
        description     = group.description
        tags            = group.tags
        template        = group.template
        started         = group.started
        machine         = group.machine
        keyboard_layout = "en-us"
        migrate         = false
        on_boot         = group.on_boot
        reboot          = false
        stop_on_destroy = true
        node_name       = node_name
        vm_id           = group.vm_id_base + node.id
        agent_enabled   = true
        boot_order      = ["virtio0"]
        image_key       = group.image_key
        disk = {
          datastore_id = group.disk.datastore_id
          interface    = group.disk.interface
          iothread     = group.disk.iothread
          size         = group.disk.size
        }
        initialization = {
          datastore_id   = group.initialization.datastore_id
          interface      = group.initialization.interface
          upgrade        = group.initialization.upgrade
          cloud_init_key = try(group.cloud_init.enabled, true) && group.cloud_init.mode == "per_node" ? "${group_key}_${node_name}" : null
          dns            = group.initialization.dns
          ip_configs = [
            for ip_config in group.ip_configs : {
              ipv4 = {
                address = replace(replace(ip_config.ipv4_address_template, "{node_name}", node_name), "{node_id}", tostring(node.id))
                gateway = ip_config.gateway
              }
            }
          ]
          user_account = group.initialization.user_account
        }
        network_devices       = group.networks
        serial_devices        = group.serial_devices
        operating_system_type = group.operating_system_type
        vga                   = group.vga
        cpu = {
          cores      = group.cpu.cores
          flags      = group.cpu.flags
          hotplugged = group.cpu.hotplugged
          limit      = group.cpu.limit
          numa       = group.cpu.numa
          sockets    = group.cpu.sockets
          type       = group.cpu.type
          units      = group.cpu.units
        }
        memory = group.memory
        timeouts = {
          clone       = 1800
          create      = 1800
          migrate     = 1800
          reboot      = 1800
          shutdown_vm = 1800
          start_vm    = 1800
          stop_vm     = 300
        }
      }
    } if group.enabled
  ])...)

  expanded_vms = merge(local.standalone_vms, local.expanded_group_vms)
}
