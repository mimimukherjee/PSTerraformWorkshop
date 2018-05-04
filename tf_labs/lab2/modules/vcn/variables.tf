variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}


variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "env_prefix" {
    default = "Test" 
}

variable "WebSubnetCnt" {
    default = "1"
}

variable "DBSubnetCnt" {
    default = "1"
}

variable "AdminSubnetCnt" {
    default = "3"
}

variable "AdminInstanceShape" {
    default = "VM.Standard1.1"
}

variable "InstanceImageDisplayName" {
    default = "Oracle-Linux-7.4-2018.02.21-1"
}

variable "provLB" {
    default = "true"
}


