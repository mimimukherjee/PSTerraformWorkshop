resource "oci_core_instance" "WorkshopInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "WorkshopInstance"
  hostname_label = "workshop1"
  #image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${oci_core_subnet.WorkshopSubnet.id}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }
  
  source_details {
    source_type = "image"
    source_id = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  }

  timeouts {
    create = "60m"
  }
}