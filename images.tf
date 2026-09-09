module "proxmox_download_files" {
  source = "./modules/proxmox_download_files"

  download_files = var.download_files
}
