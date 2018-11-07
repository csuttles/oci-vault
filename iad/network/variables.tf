variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
  version          = "~> 3.1.0"
}
# Configure the Oracle Cloud Infrastructure provider with an API Key
terraform {
  backend "s3" {
    bucket   = "oci-vault"
    key      = "iad/network/terraform.tfstate"
    region   = "us-ashburn-1"
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
# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket   = "oci-vault"
    key      = "common/terraform.tfstate"
    region   = "us-ashburn-1"
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

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}

output "vault_subnets" {
 value = ["${oci_core_subnet.oci_vault.*.id}"]
}
