variable "download_files" {
  description = "Proxmox files to download, keyed by a stable logical image name."
  type = map(object({
    content_type        = string
    datastore_id        = string
    node_name           = string
    url                 = string
    file_name           = string
    overwrite_unmanaged = optional(bool, true)
    overwrite           = optional(bool)
  }))
}
