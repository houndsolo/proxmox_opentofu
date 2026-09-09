data "local_file" "ssh_public_key" {
  filename = "./id_rsa.pub"
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = local.all_cloud_init_files

  content_type = each.value.content_type
  datastore_id = each.value.datastore_id
  node_name    = each.value.node_name

  source_raw {
    data = "#cloud-config\n${yamlencode({
      timezone       = each.value.timezone
      hostname       = each.value.hostname
      package_update = each.value.package_update
      packages       = each.value.packages
      runcmd         = each.value.runcmd
      users = [
        "default",
        {
          name                = each.value.username
          groups              = each.value.groups
          shell               = each.value.shell
          ssh_authorized_keys = [trimspace(data.local_file.ssh_public_key.content)]
          sudo                = each.value.sudo
        }
      ]
    })}"

    file_name = each.value.file_name
  }
}
