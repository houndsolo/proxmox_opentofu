data "proxmox_virtual_environment_nodes" "available_nodes" {}
data "proxmox_virtual_environment_vms" "all_vms" {}
data "proxmox_virtual_environment_containers" "all_lxcs" {}
data "proxmox_version" "pve_version" {}
