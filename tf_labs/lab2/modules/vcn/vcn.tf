
resource "oci_core_virtual_network" "VCN" {
  cidr_block = "${var.VCN-CIDR}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}VCN"
}

resource "oci_core_internet_gateway" "IG" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}IG"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
}

resource "oci_core_route_table" "PublicRT" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    display_name = "${var.env_prefix}PublicRouteTable"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.IG.id}"
    }
}


resource "oci_core_route_table" "PrivateRT" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    display_name = "${var.env_prefix}PrivateRouteTable"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_private_ip.NatPrivateIP.id}"
    }
}


resource "oci_core_security_list" "WebSecList" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}WebSecList"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    //ingress from internet via http port
    ingress_security_rules = [{
        tcp_options {
            "max" = 80
            "min" = 80
        }
        protocol = "6"
        source = "${var.provLB == "false" ? "0.0.0.0/0" : var.VCN-CIDR}"
    },
	{
        tcp_options {
            "max" = 22
            "min" = 22
        }
	protocol = "6"
	source = "${var.VCN-CIDR}"
    }]
}

resource "oci_core_subnet" "WebSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "10.0.${count.index + 1}.0/24"
  display_name = "${var.env_prefix}WebSubnetAD${count.index + 1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.VCN.id}"
  route_table_id = "${oci_core_route_table.PublicRT.id}"
  security_list_ids = ["${oci_core_security_list.WebSecList.id}"]
  dhcp_options_id = "${oci_core_virtual_network.VCN.default_dhcp_options_id}"
  count = "${var.WebSubnetCnt}"
}



resource "oci_core_security_list" "DBSecList" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}DBSecList"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    egress_security_rules = [{
	protocol = "all"
	destination = "0.0.0.0/0"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 22
            "min" = 22
        }
        protocol = "6"
        source = "${var.VCN-CIDR}"
    }, {
        tcp_options { //mysql port
            "max" = 3306
            "min" = 3306
        }
	protocol = "6"
	source = "${var.VCN-CIDR}"
    }]
}

resource "oci_core_subnet" "DBSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "10.0.${count.index + 4}.0/24"
  display_name = "${var.env_prefix}DBSubnetAD${count.index + 1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.VCN.id}"
  route_table_id = "${oci_core_route_table.PrivateRT.id}"
  security_list_ids = ["${oci_core_security_list.DBSecList.id}"]
  dhcp_options_id = "${oci_core_virtual_network.VCN.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
  count = "${var.DBSubnetCnt}"
}



resource "oci_core_security_list" "LBSecList" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}LBSecList"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    //ingress from internet via http port
    ingress_security_rules = [{
        tcp_options {
            "max" = 80
            "min" = 80
        }
        protocol = "6"
        source = "0.0.0.0/0"
    }]
}

resource "oci_core_security_list" "AdminSecList" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}AdminSecList"
    vcn_id = "${oci_core_virtual_network.VCN.id}"
    egress_security_rules = [{
	protocol = "6"
        destination = "0.0.0.0/0"
    }]
    ingress_security_rules = [{
        tcp_options {
            "max" = 22
            "min" = 22
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
	{
	protocol = "6"
        source = "${var.VCN-CIDR}"
    }]	
}

resource "oci_core_subnet" "AdminSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "10.0.${count.index + 7}.0/24"
  display_name = "${var.env_prefix}AdminSubnetAD${count.index + 1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.VCN.id}"
  route_table_id = "${oci_core_route_table.PublicRT.id}"
  security_list_ids = ["${oci_core_security_list.AdminSecList.id}"]
  dhcp_options_id = "${oci_core_virtual_network.VCN.default_dhcp_options_id}"
  count = "${var.AdminSubnetCnt}"
}


locals {
  admin_ad = "${length(oci_core_subnet.AdminSubnet.*.id) - 1}" 
}


/* Instances */


resource "oci_core_instance" "NatGateway" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[local.admin_ad],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}-NatGateway"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.AdminInstanceShape}"

  create_vnic_details {
    subnet_id = "${element(oci_core_subnet.AdminSubnet.*.id, local.admin_ad)}"
    display_name = "primaryvnic"
    skip_source_dest_check = true
  },

  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${path.module}/userdata/nat_bootstrap"))}"
  }

  timeouts {
    create = "60m"
  }

}
