variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}


variable "DBSubnet_ocids" {
  type    = "list"
}

variable "DBInstanceShape" {
    default = "VM.Standard1.2"
}

variable "InstanceImageDisplayName" {
    default = "Oracle-Linux-7.4-2018.02.21-1"
}

variable "env_prefix" {
    default = "Test" 
}


