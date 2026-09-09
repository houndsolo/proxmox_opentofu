output "file_ids" {
  description = "Downloaded Proxmox file IDs keyed by the logical image name."
  value = {
    for k, v in proxmox_virtual_environment_download_file.this : k => v.id
  }
}
