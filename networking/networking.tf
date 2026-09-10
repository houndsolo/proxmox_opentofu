resource "proxmox_network_linux_bond" "this" {
  depends_on = [proxmox_network_linux_eth.this]
  for_each   = var.pve_network.bonds
  node_name  = var.pve_host
  #autostart = false
  name                  = "bond${each.key}"
  mtu                   = each.value.mtu
  bond_mode             = each.value.bond_mode
  bond_xmit_hash_policy = each.value.bond_xmit_hash_policy
  slaves                = each.value.slaves
  comment               = each.value.description
}

resource "proxmox_network_linux_eth" "this" {
  for_each  = var.pve_network.eths
  node_name = var.pve_host
  #autostart = false
  name    = "eth${each.key}"
  mtu     = each.value.mtu
  comment = each.value.description
}

resource "proxmox_network_linux_bridge" "this" {
  depends_on = [proxmox_network_linux_eth.this]
  for_each   = var.pve_network.bridges
  node_name  = var.pve_host

  name       = "vmbr${each.key}"
  mtu        = each.value.mtu
  comment    = each.value.description
  vlan_aware = each.value.vlan_aware
  gateway    = each.value.gateway
  address = try(
    "${cidrhost(each.value.ipv4.cidrhost_prefix, var.pve_host_id)}/${each.value.ipv4.cidr}",
    null
  )
  ports = each.value.ports
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "proxmox_network_linux_vlan" "this" {
  depends_on = [proxmox_network_linux_bridge.this, proxmox_network_linux_bond.this]
  for_each   = var.pve_network.vlans
  node_name  = var.pve_host

  name    = "${each.value.port}.${each.key}"
  mtu     = each.value.mtu
  comment = each.value.description
  gateway = each.value.gateway
  address = try(
    "${cidrhost(each.value.ipv4.cidrhost_prefix, var.pve_host_id)}/${each.value.ipv4.cidr}",
    null
  )
  lifecycle {
    ignore_changes = [
    ]
  }

  ## or alternatively, use custom name:
  #name      = "monitoring_vlan"
  #interface = "eth5"
  #vlan      = 5
}
