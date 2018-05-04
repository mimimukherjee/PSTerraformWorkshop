

resource "oci_core_security_list" "LBSecList" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${var.env_prefix}LBSecList"
    vcn_id = "${var.vcn_ocid}"
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


resource "oci_core_subnet" "LBSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "10.0.${count.index + 10}.0/24"
  display_name = "${var.env_prefix}LBSubnetAD${count.index + 1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  route_table_id = "${var.rt_ocid}"
  security_list_ids = ["${oci_core_security_list.LBSecList.id}"]
  count = "2"
}

                                                        
/* Load Balancer */

resource "oci_load_balancer" "lb" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = [ "${oci_core_subnet.LBSubnet.*.id}" ]
  display_name   = "${var.env_prefix}-lb"
}

resource "oci_load_balancer_backendset" "lb-bes" {
  name             = "${var.env_prefix}-lb-bes"
  load_balancer_id = "${oci_load_balancer.lb.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "80"
    protocol = "HTTP"
    response_body_regex = ".*"
    url_path = "/"
  }
}


resource "oci_load_balancer_listener" "lb-http-listener" {
  load_balancer_id         = "${oci_load_balancer.lb.id}"
  name                     = "${var.env_prefix}-lb-http-listener"
  default_backend_set_name = "${oci_load_balancer_backendset.lb-bes.id}"
  port                     = 80
  protocol                 = "HTTP"
}


resource "oci_load_balancer_backend" "lb-be" {
  load_balancer_id = "${oci_load_balancer.lb.id}"
  backendset_name  = "${oci_load_balancer_backendset.lb-bes.id}"
  ip_address       = "${element(var.WebServerPrivIPs, count.index)}"
  count            = "${var.WebServerCnt}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}



output "lb_public_ip" {
  value = ["${oci_load_balancer.lb.ip_addresses}"]
}
