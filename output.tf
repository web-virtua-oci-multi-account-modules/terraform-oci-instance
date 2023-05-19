output "instance" {
  description = "Instance"
  value       = oci_core_instance.create_vm
}

output "instance_id" {
  description = "Instance ID"
  value       = oci_core_instance.create_vm.id
}

output "boot_volume_id" {
  description = "Boot volume ID"
  value       = oci_core_instance.create_vm.boot_volume_id
}

output "public_ip" {
  description = "Public IP"
  value       = oci_core_instance.create_vm.public_ip
}

output "private_ip" {
  description = "Private IP"
  value       = oci_core_instance.create_vm.private_ip
}

output "private_ip_id" {
  description = "Private IP ID of instance"
  value       = length(data.oci_core_private_ips.get_private_ip) >= 1 ? data.oci_core_private_ips.get_private_ip[0].private_ips[0]["id"] : null
}
