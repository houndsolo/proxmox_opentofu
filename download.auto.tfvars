download_files = {
  #arch_lxc = {
  #  content_type        = "vztmpl"
  #  datastore_id        = "cephfs"
  #  node_name           = "fichina"
  #  url                 = "https://images.linuxcontainers.org/images/archlinux/current/amd64/cloud/20260728_05:59/rootfs.tar.xz"
  #  file_name           = "arch_lxc.tar.xz"
  #  overwrite_unmanaged = true
  #  overwrite           = false
  #}
  #alpine_23_lxc = {
  #  content_type        = "vztmpl"
  #  datastore_id        = "cephfs"
  #  node_name           = "fichina"
  #  url                 = "https://images.linuxcontainers.org/images/alpine/edge/arm64/cloud/20260728_13:00/rootfs.tar.xz"
  #  file_name           = "alpine_23.tar.xz"
  #  overwrite_unmanaged = true
  #  overwrite           = false
  #}
  #debian_13_lxc = {
  #  content_type        = "vztmpl"
  #  datastore_id        = "cephfs"
  #  node_name           = "fichina"
  #  url                 = "https://images.linuxcontainers.org/images/debian/trixie/amd64/cloud/20260728_06:12/rootfs.tar.xz"
  #  file_name           = "debian_13_lxc.tar.xz"
  #  overwrite_unmanaged = true
  #  overwrite           = false
  #}
  debian_12 = {
    content_type        = "import"
    datastore_id        = "cephfs"
    node_name           = "fichina"
    url                 = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    overwrite_unmanaged = true
    overwrite           = false
  }

  debian_13 = {
    content_type        = "import"
    datastore_id        = "cephfs"
    node_name           = "fichina"
    url                 = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
    overwrite_unmanaged = true
    overwrite           = false
  }
}

