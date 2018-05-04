
resource "oci_core_virtual_network" "WorkshopVCN" {
  cidr_block = "10.0.0.0/16"
  dns_label = "workshopvcn"
  compartment_id = "${var.compartment_ocid}"
  display_name = "WorkshopVCN"
}

resource "oci_core_internet_gateway" "WorkshopIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "WorkshopIG"
  vcn_id = "${oci_core_virtual_network.WorkshopVCN.id}"
}

resource "oci_core_route_table" "WorkshopRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.WorkshopVCN.id}"
  display_name = "WorkshopRouteTable"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.WorkshopIG.id}"
  }
}


resource "oci_core_subnet" "WorkshopSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block = "10.0.1.0/24"
  display_name = "WorkshopSubnet"
  dns_label = "workshopsubnet"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.WorkshopVCN.id}}"
  security_list_ids = ["${oci_core_virtual_network.WorkshopVCN.default_security_list_id}"]
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.WorkshopVCN.id}"
  route_table_id = "${oci_core_route_table.WorkshopRT.id}"
  dhcp_options_id = "${oci_core_virtual_network.WorkshopVCN.default_dhcp_options_id}"
}

