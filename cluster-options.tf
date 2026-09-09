resource "proxmox_cluster_options" "options" {
  ha_shutdown_policy = "migrate"
  language           = "en"
  keyboard           = "en-us"
  #  email_from                = "ged@gont.earthsea"
  bandwidth_limit_migration = null
  bandwidth_limit_default   = null
  max_workers               = 4
  mac_prefix                = "BC:24:11"
  migration_cidr            = "10.22.0.0/16"
  migration_type            = "secure"
  next_id = {
    lower = 100
    upper = 999999999
  }
  #  notify = {
  #    ha_fencing_mode            = "never"
  #    ha_fencing_target          = "default-matcher"
  #    package_updates            = "always"
  #    package_updates_target     = "default-matcher"
  #    package_replication        = "always"
  #    package_replication_target = "default-matcher"
  #  }
}


#data "proxmox_virtual_environment_dns" "dns_configs" {
#  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
#  node_name = each.key
#}

resource "proxmox_virtual_environment_dns" "dns_configs" {
  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  domain    = var.dns.domain_name
  servers   = var.dns.name_servers
  node_name = each.key
}

resource "proxmox_virtual_environment_time" "first_node_time" {
  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  node_name = each.key
  time_zone = "America/New_York"
}
