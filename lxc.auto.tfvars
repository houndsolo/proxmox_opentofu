lxcs = {
  #proxmox-datacenter-manager = {
  #  description   = "managed by opentofu"
  #  node_name     = "venom"
  #  vm_id         = 660
  #  started       = true
  #  start_on_boot = true
  #  tags          = ["opentofu", "lxc", "debian"]

  #  initialization = {
  #    hostname = "proxmox-datacenter-manager"
  #    dns = {
  #      domain  = "lylat.space"
  #      servers = ["10.8.6.9"]
  #    }
  #    ip_configs = [
  #      {
  #        ipv4 = {
  #          address = "10.20.7.1/16"
  #        }
  #      },
  #      {
  #        ipv4 = {
  #          address = "10.2.7.1/16"
  #          gateway = "10.2.0.5"
  #        }
  #      },
  #      {
  #        ipv4 = {
  #          address = "10.5.7.1/16"
  #        }
  #      }
  #    ]
  #    user_account = {
  #      password = "password"
  #    }
  #  }

  #  network_interfaces = [
  #    {
  #      name    = "eth0"
  #      bridge  = "vmbr0"
  #    },
  #    {
  #      name    = "eth1"
  #      bridge  = "vmbr4000"
  #      vlan_id = 2
  #    },
  #    {
  #      name    = "eth2"
  #      bridge  = "vmbr100"
  #    }
  #  ]

  #  disk = {
  #    datastore_id = "ceph_rbd"
  #    size         = 8
  #  }

  #  features = {
  #    nesting = true
  #  }
  #  operating_system = {
  #    template_file_id = "cephfs:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  #    type = "debian"
  #  }

  #  cpu = {
  #    cores = 4
  #  }

  #  memory = {
  #    dedicated = 1024
  #    swap      = 512
  #  }
  #}
  #zabbix = {
  #  description   = "managed by opentofu"
  #  node_name     = "venom"
  #  vm_id         = 666
  #  started       = true
  #  start_on_boot = true
  #  tags          = ["opentofu", "lxc", "debian"]

  #  initialization = {
  #    hostname = "zabbix"
  #    dns = {
  #      domain  = "lylat.space"
  #      servers = ["10.8.6.9"]
  #    }
  #    ip_configs = [
  #      {
  #        ipv4 = {
  #          address = "10.20.9.1/16"
  #        }
  #      },
  #      {
  #        ipv4 = {
  #          address = "10.2.9.1/16"
  #          gateway = "10.2.0.5"
  #        }
  #      },
  #      {
  #        ipv4 = {
  #          address = "10.5.9.1/16"
  #        }
  #      }
  #    ]
  #    user_account = {
  #      password = "password"
  #    }
  #  }

  #  network_interfaces = [
  #    {
  #      name    = "eth0"
  #      bridge  = "vmbr0"
  #    },
  #    {
  #      name    = "eth1"
  #      bridge  = "vmbr4000"
  #      vlan_id = 2
  #    },
  #    {
  #      name    = "eth2"
  #      bridge  = "vmbr100"
  #    }
  #  ]

  #  disk = {
  #    datastore_id = "ceph_rbd"
  #    size         = 8
  #  }

  #  features = {
  #    nesting = true
  #  }
  #  operating_system = {
  #    template_file_id = "cephfs:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  #    type = "debian"
  #  }

  #  cpu = {
  #    cores = 4
  #  }

  #  memory = {
  #    dedicated = 1024
  #    swap      = 512
  #  }
  #}

  #  arch_lxc = {
  #    description   = "managed by opentofu"
  #    node_name     = "titania"
  #    vm_id         = 303
  #    started       = true
  #    start_on_boot = true
  #    tags          = ["opentofu", "lxc", "debian"]
  #    image_key     = "arch_lxc"
  #
  #    initialization = {
  #      hostname = "arch-lxc"
  #      dns = {
  #        domain  = "lylat.space"
  #        servers = ["10.8.6.9"]
  #      }
  #      ip_configs = [{
  #        ipv4 = {
  #          address = "10.2.11.5/16"
  #          gateway = "10.2.0.5"
  #        }
  #      }]
  #      user_account = {
  #        password = "password"
  #      }
  #    }
  #
  #    network_interfaces = [
  #      {
  #        name    = "eth0"
  #        bridge  = "vmbr0"
  #        vlan_id = 20
  #      },
  #      {
  #        name    = "eth1"
  #        bridge  = "vmbr4000"
  #        vlan_id = 2
  #      }
  #    ]
  #
  #    disk = {
  #      datastore_id = "ceph_rbd"
  #      size         = 20
  #    }
  #
  #    features = {
  #      nesting = true
  #    }
  #    operating_system = {
  #      template_file_id = "cephfs:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  #      type = "debian"
  #    }
  #
  #    cpu = {
  #      cores = 8
  #    }
  #
  #    memory = {
  #      dedicated = 8192
  #      swap      = 512
  #    }
  #  }
  #  alpine_23_test  = {
  #    description   = "managed by opentofu"
  #    node_name     = "titania"
  #    vm_id         = 301
  #    started       = true
  #    start_on_boot = true
  #    tags          = ["opentofu", "lxc", "apline"]
  #    image_key     = "alpine_23_lxc"
  #
  #    initialization = {
  #      hostname = "alpine-23-lxc"
  #      dns = {
  #        domain  = "lylat.space"
  #        servers = ["10.8.6.9"]
  #      }
  #      ip_configs = [{
  #        ipv4 = {
  #          address = "10.2.11.2/16"
  #        }
  #      }]
  #      user_account = {
  #        password = "password"
  #      }
  #    }
  #
  #    network_interfaces = [{
  #      name    = "eth0"
  #      bridge  = "vmbr4000"
  #      vlan_id = 2
  #    }]
  #
  #    disk = {
  #      datastore_id = "ceph_rbd"
  #      size         = 8
  #    }
  #
  #    features = {
  #      nesting = true
  #    }
  #    operating_system = {
  #      template_file_id = "cephfs:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  #      type = "debian"
  #    }
  #
  #    cpu = {
  #      cores = 2
  #    }
  #
  #    memory = {
  #      dedicated = 1024
  #      swap      = 512
  #    }
  #  }
  #  debian_13_example = {
  #    description   = "managed by opentofu"
  #    node_name     = "titania"
  #    vm_id         = 300
  #    started       = true
  #    start_on_boot = true
  #    tags          = ["opentofu", "lxc", "debian"]
  #    image_key     = "debian_13_lxc"
  #
  #    initialization = {
  #      hostname = "debian-13-lxc"
  #      dns = {
  #        domain  = "lylat.space"
  #        servers = ["10.8.6.9"]
  #      }
  #      ip_configs = [{
  #        ipv4 = {
  #          address = "10.2.11.1/16"
  #          gateway = "10.2.0.5"
  #        }
  #      }]
  #      user_account = {
  #        password = "password"
  #      }
  #    }
  #
  #    network_interfaces = [{
  #      name    = "eth0"
  #      bridge  = "vmbr4000"
  #      vlan_id = 2
  #    }]
  #
  #    disk = {
  #      datastore_id = "ceph_rbd"
  #      size         = 8
  #    }
  #
  #    features = {
  #      nesting = true
  #    }
  #    operating_system = {
  #      template_file_id = "cephfs:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  #      type = "debian"
  #    }
  #
  #    cpu = {
  #      cores = 2
  #    }
  #
  #    memory = {
  #      dedicated = 1024
  #      swap      = 512
  #    }
  #  }
}
