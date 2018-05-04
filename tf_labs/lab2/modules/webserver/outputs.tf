output "WebServerIPs" {
  value = "${oci_core_instance.webserver.*.public_ip}"
}
