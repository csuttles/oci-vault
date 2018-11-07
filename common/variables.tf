variable "tenancy" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
  default = "us-ashburn-1"
}
variable "compartment_ocid" {}
# Configure the Oracle Cloud Infrastructure provider with an API Key

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
  version = "~> 3.1.0"
}
terraform {
  backend "s3" {
    bucket   = "oci-vault"
    key      = "common/terraform.tfstate"
    region   = "us-ashburn-1"
    #endpoint = "https://${var.tenancy}.compat.objectstorage.${var.region}.oraclecloud.com"
    endpoint = "https://TENANCY.compat.objectstorage.REGION.oraclecloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    force_path_style            = true
    shared_credentials_file     = "/home/YOU/.aws/oci-creds"
  }
}
/*
terraform {
  backend "http" {
    update_method = "PUT"
    address       = "https://PAR_URL"
  }
}
*/
# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}
