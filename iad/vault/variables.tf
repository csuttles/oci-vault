variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "ssh_public_key" {}
variable "consul_node_to_ad_map" {
  type = "map"

  default = {
    "0" = "1"
    "1" = "1"
    "2" = "2"
    "3" = "3"
    "4" = "3"
  }
}
variable "instance_image_ocid" {
  # oci compute image list --compartment-id ocid1.compartment.oc1..derp | jq '.data[] | select(."display-name"=="CentOS-7-2018.10.12-0")'
  default = "ocid1.image.oc1.iad.aaaaaaaavujqgegoqyinkxzigumlwydq42vyf6nr3sfl7ram577zzlz2clpa"
}
variable "instance_shape" {
  default = "VM.Standard2.1"
}

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
    key      = "iad/vault/terraform.tfstate"
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

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
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
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${data.terraform_remote_state.common.vault_compartment}"
}
# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}

