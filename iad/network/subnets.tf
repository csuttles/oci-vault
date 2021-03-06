variable "availability_domain" {
  default = 3
}
/* 
Because you can specify multiple security lists/subnet the security_list_ids value must be specified as a list in []'s.
 See https://www.terraform.io/docs/configuration/syntax.html
   
Generally you wouldn't specify a subnet without first specifying a VCN. Once the VCN has been created you would get the vcn_id, route_table_id, and security_list_id(s) from that resource and use Terraform attributes below to populate those values.
 See https://www.terraform.io/docs/configuration/interpolation.html*/
resource "oci_core_subnet" "oci_vault" {
  count = 3
  //availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block          = "${format("10.0.%d.0/24", count.index + 1)}"
  display_name        = "${format("oci_vault_subnet_%d", count.index + 1)}"
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
  vcn_id              = "${oci_core_virtual_network.oci-vault-vcn1.id}"
  security_list_ids   = ["${oci_core_virtual_network.oci-vault-vcn1.default_security_list_id}"]
  route_table_id      = "${oci_core_virtual_network.oci-vault-vcn1.default_route_table_id}"
  dhcp_options_id     = "${oci_core_virtual_network.oci-vault-vcn1.default_dhcp_options_id}"
  dns_label           = "${format("vault%d", count.index + 1)}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
}

data "oci_core_subnets" "oci_vault_subnets" {
    #Required
    compartment_id = "${data.terraform_remote_state.common.network_compartment}"
    vcn_id              = "${oci_core_virtual_network.oci-vault-vcn1.id}"

    #Optional
/*
    display_name = "${var.subnet_display_name}"
    state = "${var.subnet_state}"
*/
}

output "subnets" {
    value = "${data.oci_core_subnets.oci_vault_subnets.subnets}"
}
