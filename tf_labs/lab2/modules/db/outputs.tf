output "DBIP" {
  value = "${oci_core_instance.db.private_ip}"
}
