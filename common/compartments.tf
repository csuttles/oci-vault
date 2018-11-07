resource "oci_identity_compartment" "network_compartment" {
    #Required
    description = "network compartment"
    name = "network_compartment"

    #Optional
    //defined_tags = {"Operations.CostCenter"= "42"}
    freeform_tags = {"app"="vault"}
}

resource "oci_identity_compartment" "vault_compartment" {
    #Required
    description = "vault compartment"
    name = "vault_compartment"

    #Optional
    //defined_tags = {"Operations.CostCenter"= "42"}
    freeform_tags = {"app"="vault"}
}
data "oci_identity_compartments" "compartments" {
  compartment_id = "${oci_identity_compartment.network_compartment.compartment_id}"
/*
  filter {
    name   = "name"
    values = ["tf-example-compartment"]
  }
*/
}

data "oci_identity_compartments" "network_compartment" {
    #Required
    compartment_id = "${oci_identity_compartment.network_compartment.compartment_id}"
    
    filter {
        name   = "name"
        values  = [ "network_compartment" ]
    }
}

data "oci_identity_compartments" "vault_compartment" {
    #Required
    compartment_id = "${oci_identity_compartment.vault_compartment.compartment_id}"
    filter {
        name   = "name"
        values  = [ "vault_compartment" ]
    }
}
output "network_compartment" {
  value = "${oci_identity_compartment.network_compartment.id}"
}
output "vault_compartment" {
  value = "${oci_identity_compartment.vault_compartment.id}"
}
