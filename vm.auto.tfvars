vms = {
  ubuntu1 = {
    name        = "ubuntu1"
    description = "Ubuntu 26.04 LTS server"
    tags        = ["opentofu", "ubuntu"]
    started     = true
    template    = false
    on_boot     = true

    node_name = "zoness"
    vm_id     = 1211

    image_key = "ubuntu_2604"
    machine = "q35"

    cloud_init = {
      enabled      = true
      datastore_id = "cephfs"
      node_name    = "fichina"
      file_name    = "ubuntu1.yaml"

      hostname = "ubuntu-3080"
      username = "mechanic"

      packages = [
        "qemu-guest-agent",
        "net-tools",
        "curl",
        "git",
      ]

      runcmd = [
        "systemctl enable --now qemu-guest-agent",
        "echo 'cloud-init complete' > /tmp/cloud-config.done",
      ]
    }

    disk = {
      datastore_id = "ceph_rbd"
      interface    = "virtio0"
      iothread     = true
      size         = 32
    }

    initialization = {
      interface    = "scsi0"
      datastore_id = "ceph_rbd"
      upgrade      = true

      dns = {
        domain  = "lylat.space"
        servers = ["1.1.1.1"]
      }

      ip_configs = [
        {
          ipv4 = {
            address = "10.20.12.1/16"
          }
        },
        {
          ipv4 = {
            address = "dhcp"
          }
        }
      ]

      user_account = {
        username = "mechanic"
      }
    }

    network_devices = [
      {
        bridge = "vmbr0"
        model  = "virtio"
      },
      {
        bridge  = "vmbr4000"
        vlan_id = 12
        model   = "virtio"
      }
    ]

    serial_devices = [
      {
        device = "socket"
      }
    ]

    cpu = {
      cores = 4
      type  = "x86-64-v2-AES"
    }

    memory = {
      dedicated = 4096
    }

    operating_system_type = "l26"

    vga = {
      memory = 16
      type   = "serial0"
    }
  }
  ubuntu2 = {
    name        = "ubuntu2"
    description = "Ubuntu 26.04 LTS server"
    tags        = ["opentofu", "ubuntu"]
    started     = true
    template    = false
    on_boot     = true

    node_name = "eldarad"
    vm_id     = 1212

    image_key = "ubuntu_2604"
    machine = "q35"

    cloud_init = {
      enabled      = true
      datastore_id = "cephfs"
      node_name    = "fichina"
      file_name    = "ubuntu1.yaml"

      hostname = "ubuntu-6800"
      username = "mechanic"

      packages = [
        "qemu-guest-agent",
        "net-tools",
        "curl",
        "git",
      ]

      runcmd = [
        "systemctl enable --now qemu-guest-agent",
        "echo 'cloud-init complete' > /tmp/cloud-config.done",
      ]
    }

    disk = {
      datastore_id = "ceph_rbd"
      interface    = "virtio0"
      iothread     = true
      size         = 32
    }

    initialization = {
      interface    = "scsi0"
      datastore_id = "ceph_rbd"
      upgrade      = true

      dns = {
        domain  = "lylat.space"
        servers = ["1.1.1.1"]
      }

      ip_configs = [
        {
          ipv4 = {
            address = "10.20.12.2/16"
          }
        },
        {
          ipv4 = {
            address = "dhcp"
          }
        }
      ]

      user_account = {
        username = "mechanic"
      }
    }

    network_devices = [
      {
        bridge = "vmbr0"
        model  = "virtio"
      },
      {
        bridge  = "vmbr4000"
        vlan_id = 12
        model   = "virtio"
      }
    ]

    serial_devices = [
      {
        device = "socket"
      }
    ]

    cpu = {
      cores = 4
      type  = "x86-64-v2-AES"
    }

    memory = {
      dedicated = 4096
    }

    operating_system_type = "l26"

    vga = {
      memory = 16
      type   = "serial0"
    }
  }
  dns1 = {
    name        = "dns1"
    description = "managed by opentofu"
    tags        = ["opentofu", "debian", "vyos"]
    started     = true
    template    = false
    on_boot     = true

    node_name = "fichina"
    vm_id     = 5301
    image_key = "debian_13"

    cloud_init = {
      enabled      = true
      datastore_id = "cephfs"
      node_name    = "fichina"
      file_name    = "dns1.yaml"
      hostname     = "dns1"
      username     = "mechanic"
      packages     = ["qemu-guest-agent", "net-tools", "curl"]
      runcmd = [
        "systemctl enable qemu-guest-agent",
        "systemctl start qemu-guest-agent",
        "echo \"done\" > /tmp/cloud-config.done",
      ]
    }
    disk = {
      datastore_id = "ceph_rbd"
      interface    = "virtio0"
      iothread     = true
      size         = 10
    }

    initialization = {
      interface    = "scsi0"
      datastore_id = "ceph_rbd"
      upgrade      = false
      dns = {
        domain  = "lylat.space"
        servers = ["1.1.1.1"]
      }
      ip_configs = [
        {
          ipv4 = {
            address = "10.20.53.1/16"
          }
        },
        {
          ipv4 = {
            address = "10.8.53.1/16"
            gateway = "10.8.0.5"
          }
        }
      ]
      user_account = {
        username = "mechanic"
      }
    }

    network_devices = [
      {
        bridge = "vmbr0"
        model  = "virtio"
      },
      {
        bridge  = "vmbr4000"
        vlan_id = 8
        model   = "virtio"
      }
    ]

    serial_devices = [{ device = "socket" }]
    cpu = {
      cores = 3
    }
    memory = {
      dedicated = 3084
    }
  }

  dns2 = {
    name        = "dns2"
    description = "managed by opentofu"
    tags        = ["opentofu", "debian", "vyos"]
    started     = true
    template    = false
    on_boot     = true
    node_name   = "fortuna"
    vm_id       = 5302
    image_key   = "debian_13"

    cloud_init = {
      enabled      = true
      datastore_id = "cephfs"
      node_name    = "fichina"
      file_name    = "dns2.yaml"
      hostname     = "dns2"
      username     = "mechanic"
      packages     = ["qemu-guest-agent", "net-tools", "curl"]
      runcmd = [
        "systemctl enable qemu-guest-agent",
        "systemctl start qemu-guest-agent",
        "echo \"done\" > /tmp/cloud-config.done",
      ]
    }
    disk = {
      datastore_id = "ceph_rbd"
      interface    = "virtio0"
      iothread     = true
      size         = 10
    }

    initialization = {
      interface    = "scsi0"
      datastore_id = "ceph_rbd"
      upgrade      = false
      dns = {
        domain  = "lylat.space"
        servers = ["1.1.1.1"]
      }
      ip_configs = [
        {
          ipv4 = {
            address = "10.20.53.2/16"
          }
        },
        {
          ipv4 = {
            address = "10.8.53.2/16"
            gateway = "10.8.0.5"
          }
        }
      ]
      user_account = {
        username = "mechanic"
      }
    }

    network_devices = [
      {
        bridge = "vmbr0"
        model  = "virtio"
      },
      {
        bridge  = "vmbr4000"
        vlan_id = 8
        model   = "virtio"
      }
    ]

    serial_devices = [{ device = "socket" }]
    cpu = {
      cores = 3
    }
    memory = {
      dedicated = 3084
    }
  }

  #vyos_build = {
  #  name        = "vyos-build-vm"
  #  description = "managed by opentofu"
  #  tags        = ["opentofu", "debian", "vyos"]
  #  started     = true
  #  template    = false
  #  on_boot     = true

  #  node_name = "eldarad"
  #  vm_id     = 150
  #  image_key = "debian_12"

  #  cloud_init = {
  #    enabled      = true
  #    datastore_id = "cephfs"
  #    node_name    = "fichina"
  #    file_name    = "vyos_build-CI.yaml"
  #    hostname     = "vyos-builder"
  #    username     = "mechanic"
  #    packages     = ["qemu-guest-agent", "net-tools", "curl"]
  #    runcmd = [
  #      "systemctl enable qemu-guest-agent",
  #      "systemctl start qemu-guest-agent",
  #      "echo \"done\" > /tmp/cloud-config.done",
  #    ]
  #  }


  #  disk = {
  #    datastore_id = "ceph_rbd"
  #    interface    = "virtio0"
  #    iothread     = true
  #    size         = 20
  #  }

  #  initialization = {
  #    interface    = "scsi0"
  #    datastore_id = "ceph_rbd"
  #    upgrade      = false
  #    dns = {
  #      domain  = "lylat.space"
  #      servers = ["10.8.6.9"]
  #    }
  #    ip_configs = [
  #      {
  #        ipv4 = {
  #          address = "10.20.0.150/16"
  #        }
  #      },
  #      {
  #        ipv4 = {
  #          address = "10.5.0.150/16"
  #          gateway = "10.5.0.255"
  #        }
  #      }
  #    ]
  #    user_account = {
  #      username = "mechanic"
  #    }
  #  }

  #  network_devices = [
  #    {
  #      bridge  = "vmbr0"
  #      model   = "virtio"
  #    },
  #    {
  #      bridge  = "vmbr100"
  #      model   = "virtio"
  #    }
  #  ]

  #  serial_devices = [{ device = "socket" }]

  #  cpu = {
  #    cores = 8
  #  }

  #  memory = {
  #    dedicated = 20480
  #  }
  #}

  #vyos_build_2 = {
  #  name        = "vyos-build-2-vm"
  #  description = "managed by opentofu"
  #  tags        = ["opentofu", "debian", "vyos"]
  #  started     = false
  #  template    = false
  #  on_boot     = true

  #  node_name = "zoness"
  #  vm_id     = 151
  #  image_key = "debian_12"

  #  cloud_init = {
  #    enabled      = true
  #    datastore_id = "cephfs"
  #    node_name    = "fichina"
  #    file_name    = "vyos_build-CI.yaml"
  #    hostname     = "vyos-builder-2"
  #    username     = "mechanic"
  #    packages     = ["qemu-guest-agent", "net-tools", "curl"]
  #    runcmd = [
  #      "systemctl enable qemu-guest-agent",
  #      "systemctl start qemu-guest-agent",
  #      "echo \"done\" > /tmp/cloud-config.done",
  #    ]
  #  }


  #  disk = {
  #    datastore_id = "ceph_rbd"
  #    interface    = "virtio0"
  #    iothread     = true
  #    size         = 20
  #  }

  #  initialization = {
  #    interface    = "scsi0"
  #    datastore_id = "ceph_rbd"
  #    upgrade      = false
  #    dns = {
  #      domain  = "lylat.space"
  #      servers = ["10.8.6.9"]
  #    }
  #    ip_configs = [{
  #      ipv4 = {
  #        address = "10.2.0.151/16"
  #        gateway = "10.2.0.5"
  #      }
  #    }]
  #    user_account = {
  #      username = "mechanic"
  #    }
  #  }

  #  network_devices = [{
  #    bridge  = "vmbr4000"
  #    model   = "virtio"
  #    vlan_id = "2"
  #  }]

  #  serial_devices = [{ device = "socket" }]

  #  cpu = {
  #    cores = 20
  #  }

  #  memory = {
  #    dedicated = 20480
  #  }
  #}


  vyos_template = {
    name        = "vyos-template"
    description = "managed by opentofu"
    tags        = ["opentofu", "debian", "vyos", "template"]
    started     = false
    template    = true
    on_boot     = true

    node_name = "eldarad"
    vm_id     = 999999

    cloud_init = {
      enabled      = true
      datastore_id = "cephfs"
      node_name    = "fichina"
      file_name    = "vyos_template.yaml"
      hostname     = "vyos-template"
      username     = "mechanic"
      packages     = []
      runcmd       = []
    }


    disk = {
      datastore_id = "ceph_rbd"
      import_from  = "cephfs:import/vyos-1.5-rolling-202606080213-qcow2-amd64.qcow2"
      interface    = "virtio0"
      iothread     = true
      size         = 10
    }

    initialization = {
      interface    = "scsi0"
      datastore_id = "ceph_rbd"
      upgrade      = false
      ip_configs = [{
        ipv4 = {
          address = "10.20.10.199/16"
        }
      }]
      user_account = {
        username = "mechanic"
      }
    }

    network_devices = [
      {
        bridge  = "vmbr1"
        model   = "virtio"
        vlan_id = "20"
      },
      {
        bridge  = "vmbr1"
        model   = "virtio"
        vlan_id = "1111"
      },
      {
        bridge  = "vmbr1"
        model   = "virtio"
        vlan_id = "1112"
      },
    ]

    serial_devices = [{ device = "socket" }]

    cpu = {
      cores = 4
    }

    memory = {
      dedicated = 4096
    }

    operating_system_type = "l26"

    vga = {
      memory = 16
      type   = "std"
    }
  }
}

vm_groups = {
  #test_hosts = {
  #  enabled     = true
  #  name_prefix = "test-host"
  #  vm_id_base  = 1700
  #  image_key   = "debian_13"
  #  tags        = ["opentofu", "debian", "test-host"]
  #  started     = true
  #  template    = false
  #  on_boot     = true

  #  cloud_init = {
  #    mode              = "per_node"
  #    datastore_id      = "cephfs"
  #    node_name         = "fichina"
  #    file_name_pattern = "test-host-CI-{node_name}.yaml"
  #    hostname_pattern  = "test-host-{node_name}"
  #    username          = "mechanic"
  #    packages          = ["qemu-guest-agent", "net-tools", "curl"]
  #    runcmd = [
  #      "systemctl enable qemu-guest-agent",
  #      "systemctl start qemu-guest-agent",
  #      "echo \"done\" > /tmp/cloud-config.done",
  #    ]
  #  }

  #  disk = {
  #    datastore_id = "ceph_rbd"
  #    interface    = "virtio0"
  #    size         = 20
  #    iothread     = true
  #  }

  #  initialization = {
  #    datastore_id = "ceph_rbd"
  #    interface    = "scsi0"
  #    upgrade      = false
  #    dns = {
  #      domain  = "lylat.space"
  #      servers = ["10.8.6.9"]
  #    }
  #    user_account = {
  #      username = "mechanic"
  #    }
  #  }

  #  networks = [
  #    {
  #      bridge  = "vmbr4000"
  #      vlan_id = 8
  #      model   = "virtio"
  #    },
  #    {
  #      bridge  = "vmbr4000"
  #      vlan_id = 6
  #      model   = "virtio"
  #    },
  #  ]

  #  ip_configs = [
  #    {
  #      ipv4_address_template = "10.8.200.{node_id}/16"
  #      gateway               = "10.8.0.5"
  #    },
  #    {
  #      ipv4_address_template = "10.6.200.{node_id}/16"
  #    },
  #  ]

  #  cpu = {
  #    cores   = 4
  #    type    = "x86-64-v2-AES"
  #    sockets = 1
  #    units   = 1024
  #  }

  #  memory = {
  #    dedicated = 4096
  #  }

  #  operating_system_type = "l26"

  #  vga = {
  #    memory = 16
  #    type   = "serial0"
  #  }
  #}
}
