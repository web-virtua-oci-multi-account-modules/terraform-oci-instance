data "oci_core_vnic_attachments" "get_vnic_attachments" {
  count = var.has_public_ip ? 1 : 0

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  instance_id         = oci_core_instance.create_vm.id

  depends_on = [
    oci_core_instance.create_vm
  ]
}

data "oci_core_vnic" "create_vnic" {
  count = length(data.oci_core_vnic_attachments.get_vnic_attachments) >= 1 ? 1 : 0

  vnic_id = data.oci_core_vnic_attachments.get_vnic_attachments[0].vnic_attachments[0]["vnic_id"]

  depends_on = [
    data.oci_core_vnic_attachments.get_vnic_attachments
  ]
}

data "oci_core_private_ips" "get_private_ip" {
  count = length(data.oci_core_vnic.create_vnic) >= 1 ? 1 : 0

  vnic_id = data.oci_core_vnic.create_vnic[0].id
}
