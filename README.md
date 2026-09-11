# proxmox_opentofu

A Proxmox VE integration with OpenTofu for infrastructure as code management.

## Purpose

This repository automates the provisioning and management of Proxmox Virtual Environment (PVE) infrastructure using OpenTofu.

## Current State

- **OpenTofu**: This project now uses OpenTofu (not Terraform)
- **Provider**: Using custom local provider `local/mechanic/proxmox` v0.111.0

## Directory Structure

```
.
├── main.tf                # Module calls and orchestration
├── providers.tf           # Local Proxmox provider configuration
├── versions.tf            # OpenTofu version requirements
├── vars.tf                # Variable declarations (use placeholders)
├── data.tf                # Data source definitions
├── outputs.tf             # Output value definitions
├── locals.tf              # Local variable definitions
├── passwords.tf           # Credential management
├── cloud_init.tf          # Cloud-init configuration
├── cluster-options.tf     # Cluster configuration options
├── metrics.tf             # Metrics/diagnostics monitoring
│
├── vm.tf                  # VM provisioning logic
├── lxc.tf                 # LXC container provisioning logic  
├── images.tf              # Image management
│
└── modules/
    └── proxmox_download_files/  # Downloaded file module
        ├── main.tf
        ├── outputs.tf
        ├── variables.tf
        └── versions.tf
│
├── networking/           # Network configuration
│   ├── networking.tf           # Network provisioning logic
│   ├── vars.tf                 # Network variables (use placeholders)
│   └── versions.tf             # Version requirements
│
├── sdn/                  # Software-defined networking
│   ├── networking.tf  # SDN network provisionin logic
│   ├── vars.tf        # SDN variables (use placeholders)
│   └── versions.tf    # Version requirements
```

## Features

- **VM Provisioning**: Automated VM lifecycle management
- **LXC Containers**: LXC container creation and configuration
- **Networking**: Network setup across Proxmox cluster nodes
- **SDN Integration**: Software-defined networking capabilities
- **File Downloads**: Module for downloading files to Proxmox
- **Cluster Management**: Multi-node cluster coordination
- **Cloud-init Support**: Automated OS provisioning via cloud-init

## OpenTofu Version

This project uses OpenTofu v1.x (exact version determined by tofu.lock). The required providers are defined in [versions.tf](versions.tf):

| Provider | Source | Version |
|----------|--------|---------|
| proxmox | local/mechanic/proxmox | 0.111.0 |
| local | hashicorp/local | (auto) |

## Outputs Summary

The following important outputs are defined in [outputs.tf](outputs.tf):

| Output Name | Description | Example Usage |
|-------------|-------------|----------------|
| `image_file_ids` | Downloaded image file IDs keyed by image_key. | `tofu output 'image_file_ids'` |
| `cloud_init_file_ids` | Cloud-init snippet file IDs keyed by cloud_init_key. | `tofu output 'cloud_init_file_ids'` |
| `vm_ids` | Managed VM IDs keyed by VM key. | `tofu output 'vm_ids'` |
| `lxc_ids` | Managed LXC IDs keyed by LXC key. | `tofu output 'lxc_ids'` |

## Troubleshooting

### Common Issues

#### SSH Connection Failures to Proxmox Nodes
- Verify the SSH private key exists at `~/.ssh/id_rsa` with correct permissions (`600`)
- Check that the public key is added to `~/.ssh/authorized_keys` on all cluster nodes (fichina, macbeth, titania, zoness, fortuna, eldarad, venom)
- Ensure network connectivity to Proxmox API endpoint at port 8006

#### Provider Connection Errors
- Confirm Proxmox API credentials in `providers.tf` are correct
- Verify cluster node list matches actual environment
- Check that firewall rules allow connections on port 8006 (API) and 22 (SSH)

#### State File Issues
- Ensure `.tfstate` files have appropriate permissions (`chmod 600`)
- For multi-node setups, review `proxmox_cluster.auto.tfvars` for cluster state configuration

#### Module Errors
- Verify all submodules exist: `modules/proxmox_download_files/`, `networking/`, `sdn/`
- Check `versions.tf` files in subdirectories contain valid OpenTofu version requirements
- Run `tofu init` to reinitialize the provider and workspace

### File Path Verification

All file paths referenced in this project are located at:

| Path | Purpose |
|------|---------|
| `main.tf` | Module calls and orchestration |
| `providers.tf` | Local Proxmox provider configuration |
| `versions.tf` | OpenTofu version requirements (root) |
| `vars.tf` | Variable declarations (use placeholders for secrets) |
| `data.tf` | Data source definitions |
| `outputs.tf` | Output value definitions |
| `locals.tf` | Local variable definitions |
| `passwords.tf` | Credential management |
| `cloud_init.tf` | Cloud-init configuration |
| `cluster-options.tf` | Cluster configuration options |
| `metrics.tf` | Metrics/diagnostics monitoring |
| `vm.tf` | VM provisioning logic |
| `lxc.tf` | LXC container provisioning logic |
| `images.tf` | Image management |
| `dns.auto.tfvars` | Dynamic DNS configuration |
| `download.auto.tfvars` | Download module variables |
| `fabric.auto.tfvars` | Fabric networking configuration |
| `lxc.auto.tfvars` | LXC container variables |
| `proxmox_cluster.auto.tfvars` | Cluster-wide variables |
| `vm.auto.tfvars` | VM-specific variables |
| `vnis.auto.tfvars` | VNI configuration |
| `networking/networking.tf` | Network provisioning logic |
| `networking/vars.tf` | Network variables (use placeholders) |
| `networking/versions.tf` | Network version requirements |
| `networking/fichina_sdn/` | fichina SDN configuration |
| `networking/gf_sdn/` | gf SDN configuration |
| `sdn/networking.tf` | SDN network provisioning logic |
| `sdn/vars.tf` | SDN variables (use placeholders) |
| `sdn/versions.tf` | SDN version requirements |

## Security Notes

- Use placeholder values like `TOFU_VAR_API_TOKEN_HERE` in `vars.tf` for sensitive credentials
- SSH keys are expected at `~/.ssh/id_rsa` with restricted permissions (`600`)
- Never commit actual API tokens or private keys to version control
- Review `passwords.tf.example` for credential template format before use

## Getting Started

1. Clone this repository to your local system
2. Configure Proxmox connection in `providers.tf` with SSH access
3. Edit `vars.tf` to add your variables (use placeholder syntax like `[API_TOKEN_HERE]` for secrets)
4. Run `tofu init` to initialize the configuration
5. Review available documentation and run `tofu plan` before applying changes

## Development Workflow

1. Make changes to provisioned resources (VMs, LXCs, networks, SDN, etc.)
2. Verify changes with `tofu plan`
3. Apply infrastructure changes with `tofu apply`
4. Review outputs and manage state in `.tfstate` files

## Auto Variables Files

The following auto TFvars files are used for dynamic variable assignment:

- `dns.auto.tfvars` - Dynamic DNS configuration
- `download.auto.tfvars` - Download module variables
- `fabric.auto.tfvars` - Fabric networking configuration
- `lxc.auto.tfvars` - LXC container variables
- `proxmox_cluster.auto.tfvars` - Cluster-wide variables
- `vm.auto.tfvars` - VM-specific variables
- `vnis.auto.tfvars` - VNI configuration

## License

MIT License - see LICENSE file

## Configuration

### Proxmox Nodes

The provider connects to a Proxmox cluster with SSH access to nodes:

| Node Name  | IP Address     |
|------------|----------------|
| fichina    | 10.20.7.11     |
| macbeth    | 10.20.7.12     |
| titania    | 10.20.7.13     |
| zoness     | 10.20.7.14     |
| fortuna    | 10.20.7.15     |
| eldarad    | 10.20.7.16     |
| venom      | 10.20.7.17     |

### SDN Module

The SDN module is used for Software-Defined Networking configuration on Proxmox nodes.

### Network Configuration

The cluster uses the network: `10.20.7.0/24` with API endpoint at port `8006`.
