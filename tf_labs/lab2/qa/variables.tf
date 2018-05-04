variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}


variable "WebInstanceShape" {
    default = "VM.Standard2.1"
}

variable "DBInstanceShape" {
    default = "VM.Standard1.2"
}

variable "AdminInstanceShape" {
    default = "VM.Standard1.1"
}

variable "env_prefix" {
    default = "QA" 
}

variable "WebServerCnt" {
    default = "1"
}

variable "WebSubnetCnt" {
    default = "1"
}

