
/* Instances */


resource "oci_core_instance" "db" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.env_prefix}-db"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.DBInstanceShape}"

  create_vnic_details {
    subnet_id = "${var.DBSubnet_ocids[0]}"
    display_name = "primaryvnic"
    assign_public_ip = false
  },

  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file("${path.module}/userdata/db_bootstrap"))}"
  }

  timeouts {
    create = "60m"
  }
  
}
