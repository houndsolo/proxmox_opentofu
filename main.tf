module "pve_networking" {
  source      = "./networking"
  for_each    = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  pve_api_key = var.pve_api_token
  pve_network = var.pve_network
  pve_host    = each.value
  pve_host_id = var.pve_nodes[each.value].id
}

#module "sdn" {
#  source      = "./sdn"
#  for_each    = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
#  pve_api_key = var.pve_api_token
#  pve_network = var.pve_network
#  pve_host    = each.value
#  pve_host_id = var.pve_nodes[each.value].id
#}
