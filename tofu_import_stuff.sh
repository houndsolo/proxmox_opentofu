#!/usr/bin/env bash
set -euo pipefail

#tofu import --var-file=tfvars/proxmox_cluster.tfvars  --var-file=tfvars/vm.tfvars  --var-file=tfvars/vxlan_fabric.tfvars

nodes=(
  fichina
  fortuna
  macbeth
  titania
  zoness
  venom
  eldarad
)

bridges=(
  1
  0
  100
  7
  4000
  4001
  4002
  4010
  4011
  4012
  22
  27
)

eths=(
  0
  1
  10
  7
  4001
  4002
  22
  27
)

# "vlan_id parent_interface"
bonds=(
  "0"
)
vlans=(
  "2 vmbr4000"
#  "5 vmbr100"
  "22 bond0"
  "27 bond0"
)

for node in "${nodes[@]}"; do
 for vlan_pair in "${vlans[@]}"; do
    read -r vlan_id parent_interface <<< "$vlan_pair"

tofu import \
      "module.pve_networking[\"${node}\"].proxmox_network_linux_vlan.this[\"${vlan_id}\"]" \
      "${node}:${parent_interface}.${vlan_id}"
  done

  for bond in "${bonds[@]}"; do
tofu import \
      "module.pve_networking[\"${node}\"].proxmox_network_linux_bond.this[\"${bond}\"]" \
      "${node}:bond${bond}"
  done

  for eth in "${eths[@]}"; do
tofu import \
      "module.pve_networking[\"${node}\"].proxmox_network_linux_eth.this[\"${eth}\"]" \
      "${node}:eth${eth}"
  done

  for br in "${bridges[@]}"; do
tofu import \
      "module.pve_networking[\"${node}\"].proxmox_network_linux_bridge.this[\"${br}\"]" \
      "${node}:vmbr${br}"
  done
done
