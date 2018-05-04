resource "null_resource" "config_nodejs_bootstrap" {
  provisioner "local-exec" {
    command = "sed \"s/__DB_PRIVATE_IP_/${var.DBIP}/g\" ${path.module}/userdata/nodejs_bootstrap.template > ${path.module}/userdata/nodejs_bootstrap "
  }
}

/* Instances */
resource "oci_core_instance" "webserver" {
  depends_on = [ "null_resource.config_nodejs_bootstrap" ]
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[(count.index % var.WebSubnetCnt)],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}-webserver-${count.index + 1}"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.WebInstanceShape}"
  count = "${var.WebServerCnt}"

  create_vnic_details {
    subnet_id = "${element(var.WebSubnet_ocids, count.index % var.WebSubnetCnt)}"
    display_name = "primaryvnic"
    assign_public_ip = true
  },

  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${path.module}/userdata/nodejs_bootstrap"))}"
  }

  timeouts {
    create = "60m"
  }


}
