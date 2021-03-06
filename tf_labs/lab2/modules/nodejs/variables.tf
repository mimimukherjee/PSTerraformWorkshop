variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}


variable "WebSubnet_ocids" {
  type    = "list"
}

variable "WebInstanceShape" {
    default = "VM.Standard2.1"
}

variable "InstanceImageDisplayName" {
    default = "Oracle-Linux-7.4-2018.02.21-1"
}

variable "env_prefix" {
    default = "Test" 
}

variable "WebServerCnt" {
    default = "1"
}

variable "WebSubnetCnt" {
    default = "1"
}

variable "DBIP" {
}

