variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}


variable "WebSubnet_ocids" {
  type    = "list"
}

variable "InstanceShape" {
    default = "VM.Standard2.1"
}

variable "InstanceImageDisplayName" {
    default = "Oracle-Linux-7.4-2018.02.21-1"
}

variable "env_prefix" {
    default = "Test" 
}

variable "DBSize" {
    default = "50" // size in GBs
}

variable "WebServerCnt" {
    default = "1"
}

variable "SubnetCnt" {
    default = "1"
}

