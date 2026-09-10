resource "proxmox_metrics_server" "influxdb_server" {
  name                = "influxdb"
  server              = "10.5.11.30"
  port                = 8086
  type                = "influxdb"
  influx_db_proto     = "http"
  influx_organization = "lylat.space"
  influx_bucket       = "metrics"
  influx_token        = var.influx_api_token
  influx_verify       = false
  mtu                 = 1500
  disable             = true
  lifecycle {
    ignore_changes = [
      influx_token
    ]
  }
}
