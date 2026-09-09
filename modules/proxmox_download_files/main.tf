resource "proxmox_virtual_environment_download_file" "this" {
  for_each = var.download_files

  content_type        = each.value.content_type
  datastore_id        = each.value.datastore_id
  node_name           = each.value.node_name
  url                 = each.value.url
  file_name           = each.value.file_name
  overwrite_unmanaged = try(each.value.overwrite_unmanaged, true)
  overwrite           = try(each.value.overwrite, null)
}
