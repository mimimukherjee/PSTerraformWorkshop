resource "oci_core_volume" "WorkshopBV" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "WorkshopBV"
  size_in_gbs = "${var.DBSize}"
}

resource "oci_core_volume_attachment" "WorkshopBVAttach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${oci_core_instance.WorkshopInstance.id}"
    volume_id = "${oci_core_volume.WorkshopBV.id}"


    provisioner "local-exec" {
        command = "sed \"s/__IQN__/${oci_core_volume_attachment.WorkshopBVAttach.iqn}/g\" ./scripts/bv_mount.template | sed \"s/__IPV4_PORT__/${oci_core_volume_attachment.WorkshopBVAttach.ipv4}:${oci_core_volume_attachment.WorkshopBVAttach.port}/g\"  >./scripts/bv_mount.sh "
    }

    provisioner "file" {
        connection {
            agent = false
            timeout = "10m"
            host = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
            user = "opc"
            private_key = "${var.ssh_private_key}"
        }
        source = "./scripts/bv_mount.sh"
        destination = "~/bv_mount.sh"
    }

    provisioner "remote-exec" {
        connection {
        agent = false
        timeout = "30m"
        host = "${data.oci_core_vnic.InstanceVnic.public_ip_address}"
        user = "opc"
        private_key = "${var.ssh_private_key}"
        }
        inline = [
                        "chmod +x ~/bv_mount.sh",
                        "sudo ~/bv_mount.sh",
        ]
    }


}

