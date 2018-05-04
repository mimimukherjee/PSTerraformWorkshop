output "WebServerPubIPs" {
  value = "${oci_core_instance.webserver.*.public_ip}"
}

output "WebServerPrivIPs" {
  value = "${oci_core_instance.webserver.*.private_ip}"
}
