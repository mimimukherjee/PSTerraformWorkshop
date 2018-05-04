# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

data "oci_core_images" "OLImageOCID" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.InstanceImageDisplayName}"
}


data "oci_core_vnic_attachments" "NatVnics" {
    compartment_id = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[local.admin_ad],"name")}"
    instance_id = "${oci_core_instance.NatGateway.id}"
}

# Create PrivateIP
resource "oci_core_private_ip" "NatPrivateIP" {
    vnic_id = "${lookup(data.oci_core_vnic_attachments.NatVnics.vnic_attachments[0],"vnic_id")}"
    display_name = "NatPrivateIP"
}


