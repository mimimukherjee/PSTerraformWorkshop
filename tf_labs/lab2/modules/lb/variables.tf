variable "tenancy_ocid" {}
variable "compartment_ocid" {}

variable "vcn_ocid" {} 
variable "rt_ocid" {} 
variable "WebServerPrivIPs" {
  type = "list"
} 


variable "env_prefix" {
    default = "Test" 
}


variable "WebServerCnt" {
    default = "1" 
}

