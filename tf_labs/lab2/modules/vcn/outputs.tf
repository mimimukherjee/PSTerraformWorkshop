output "vcn_ocid" {
  value = "${oci_core_virtual_network.VCN.id}"
}

output "public_rt_ocid" {
  value = "${oci_core_route_table.PublicRT.id}"
}

output "private_rt_ocid" {
  value = "${oci_core_route_table.PrivateRT.id}"
}


output "WebSubnet_ocids" {
  value = "${oci_core_subnet.WebSubnet.*.id}"
}

output "DBSubnet_ocids" {
  value = "${oci_core_subnet.DBSubnet.*.id}"
}

