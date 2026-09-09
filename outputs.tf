output "image_file_ids" {
  description = "Downloaded image file IDs keyed by image_key."
  value       = local.image_file_ids
}

output "cloud_init_file_ids" {
  description = "Cloud-init snippet file IDs keyed by cloud_init_key."
  value       = local.cloud_init_file_ids
}

output "vm_ids" {
  description = "Managed VM IDs keyed by VM key."
  value = {
    for k, v in proxmox_virtual_environment_vm.this : k => v.vm_id
  }
}

output "lxc_ids" {
  description = "Managed LXC IDs keyed by LXC key."
  value = {
    for k, v in proxmox_virtual_environment_container.this : k => v.vm_id
  }
}
