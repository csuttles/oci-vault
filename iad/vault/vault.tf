//vault nodes
// consul nodes
resource "oci_core_instance" "vault" {
  count               = 3
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  compartment_id      = "${data.terraform_remote_state.common.vault_compartment}"
  display_name        = "vault-${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${data.terraform_remote_state.network.vault_subnets[count.index]}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "vault-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("${path.module}/user-data/vault.txt"))}"
  }
  freeform_tags = "${map("vault-server", "freeformvalue${count.index}")}"
  timeouts {
    create = "60m"
  }
}

output "vault_instances" {
 value = ["${oci_core_instance.vault.*.id}"]
}

output "vault_instance_public_ips" {
 value = ["${oci_core_instance.vault.*.public_ip}"]
}
