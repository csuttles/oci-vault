resource "oci_core_virtual_network" "oci-vault-vcn1" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "ocivault"
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
  display_name   = "oci-vault-vcn1"
}

resource "oci_core_internet_gateway" "oci-vault-ig1" {
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
  display_name   = "oci-vault-ig1"
  vcn_id         = "${oci_core_virtual_network.oci-vault-vcn1.id}"
}

resource "oci_core_default_route_table" "oci-vault-default-route-table" {
  manage_default_resource_id = "${oci_core_virtual_network.oci-vault-vcn1.default_route_table_id}"
  display_name               = "oci-vault-default-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.oci-vault-ig1.id}"
  }
}

resource "oci_core_route_table" "oci-vault-route-table1" {
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
  vcn_id         = "${oci_core_virtual_network.oci-vault-vcn1.id}"
  display_name   = "oci-vault-route-table1"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.oci-vault-ig1.id}"
  }
}

resource "oci_core_default_dhcp_options" "oci-vault-default-dhcp-options" {
  manage_default_resource_id = "${oci_core_virtual_network.oci-vault-vcn1.default_dhcp_options_id}"
  display_name               = "oci-vault-default-dhcp-options"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type                = "SearchDomain"
    search_domain_names = ["csuttles.io"]
  }
}

resource "oci_core_dhcp_options" "oci-vault-dhcp-options1" {
  compartment_id = "${data.terraform_remote_state.common.network_compartment}"
  vcn_id         = "${oci_core_virtual_network.oci-vault-vcn1.id}"
  display_name   = "oci-vault-dhcp-options1"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type                = "SearchDomain"
    search_domain_names = ["csuttles.io"]
  }
}
