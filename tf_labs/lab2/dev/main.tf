module "vcn" {
  source = "../modules/vcn"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  env_prefix = "${var.env_prefix}"
  provLB = "false"
}

module "db" {
  source = "../modules/db"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  DBSubnet_ocids = "${module.vcn.DBSubnet_ocids}"
  DBInstanceShape = "${var.DBInstanceShape}"
  env_prefix = "${var.env_prefix}"
}

/*
module "webserver" {
  source = "../modules/webserver"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  ssh_private_key = "${var.ssh_private_key}"
  WebSubnet_ocids = "${module.vcn.WebSubnet_ocids}"
  InstanceShape = "${var.InstanceShape}"
  WebServerCnt = "${var.WebServerCnt}"
  SubnetCnt = "${var.SubnetCnt}"
  env_prefix = "${var.env_prefix}"
}
*/

module "nodejs" {
  source = "../modules/nodejs"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  ssh_public_key = "${var.ssh_public_key}"
  ssh_private_key = "${var.ssh_private_key}"
  WebSubnet_ocids = "${module.vcn.WebSubnet_ocids}"
  DBIP = "${module.db.DBIP}"
  WebInstanceShape = "${var.WebInstanceShape}"
  WebServerCnt = "${var.WebServerCnt}"
  env_prefix = "${var.env_prefix}"

}

/*
output "vcn_ocid" {
  value ="${module.vcn.vcn_ocid}"
}

output "WebSubnet_ocids" {
  value = "${module.vcn.WebSubnet_ocids}"
}
*/

output "WebServerIPs" {
  //value = "${module.webserver.WebServerIPs}"
  value = "${module.nodejs.WebServerPubIPs}"
}

