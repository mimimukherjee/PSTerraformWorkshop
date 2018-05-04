
/* Instances */


resource "oci_core_instance" "webserver" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[(count.index % var.SubnetCnt)],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}-webserver-${count.index + 1}"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  count = "${var.WebServerCnt}"

  create_vnic_details {
    subnet_id = "${element(var.WebSubnet_ocids, count.index % var.SubnetCnt)}"
    display_name = "primaryvnic"
    assign_public_ip = true
  },

  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${path.module}/userdata/bootstrap"))}"
  }

  timeouts {
    create = "60m"
  }

}
