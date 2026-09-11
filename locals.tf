locals {
  image_file_ids = module.proxmox_download_files.file_ids


  proxmox_allnodes = {
    for node_name in data.proxmox_virtual_environment_nodes.available_nodes.names :
    node_name => {
      id = var.proxmox_nodes[node_name].id
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

  all_cloud_init_files = local.standalone_vm_cloud_init_files

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

  expanded_vms = local.standalone_vms
}
