resource "oci_core_default_security_list" "oci-vault-default-security-list" {
  manage_default_resource_id = "${oci_core_virtual_network.oci-vault-vcn1.default_security_list_id}"
  display_name               = "oci-vault-default-security-list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  // allow inbound vault traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 8200
      "max" = 8201
    }
  }
  // allow inbound vault traffic
  ingress_security_rules {
    protocol  = "17"         // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      "min" = 8200
      "max" = 8201
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 8300
      "max" = 8302
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "17"         // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      "min" = 8300
      "max" = 8302
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 8500
      "max" = 8502
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "17"         // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      "min" = 8500
      "max" = 8502
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 8600
      "max" = 8600
    }
  }
  // allow inbound consul traffic
  ingress_security_rules {
    protocol  = "17"         // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      "min" = 8600
      "max" = 8600
    }
  }
  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }
}
