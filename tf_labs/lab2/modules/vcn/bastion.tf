
/* Instances */


resource "oci_core_instance" "bastion" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[local.admin_ad],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}-bastion"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.AdminInstanceShape}"

  create_vnic_details {
    subnet_id = "${element(oci_core_subnet.AdminSubnet.*.id, local.admin_ad)}"
    display_name = "primaryvnic"
    assign_public_ip = true
  },

  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${path.module}/userdata/bastion_bootstrap"))}"
  }

  timeouts {
    create = "60m"
  }

}
