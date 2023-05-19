variable "name" {
  description = "Instance name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to VM"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain, ex: Uocm:PHX-AD-1"
  type        = string
  default     = null
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
  default     = null
}

variable "compartment_name" {
  description = "Compartment name"
  type        = string
  default     = null
}

variable "fault_domain" {
  description = "Fault domain"
  type        = string
  default     = "FAULT-DOMAIN-1"
}

variable "shape" {
  description = "Shape of instance, doc: https://docs.oracle.com/en-us/iaas/api/#/en/iaas/20160918/Shape/ListShapes"
  type        = string
  default     = "VM.Standard4.Flex"
}

variable "preserve_boot_volume" {
  description = "If true, will be preserved the instance"
  type        = bool
  default     = false
}

variable "is_pv_encryption_in_transit_enabled" {
  description = "If true, the encryption is enable"
  type        = bool
  default     = true
}

variable "shape_config" {
  description = "Configuration to shape flexible"
  type = object({
    memory_in_gbs             = number
    ocpus                     = number
    nvmes                     = optional(number)
    baseline_ocpu_utilization = optional(string)
  })
  default = null
}

variable "is_preemptible" {
  description = "If true the instance will be preemptible"
  type        = bool
  default     = false
}

variable "preemptible_instance_config" {
  description = "Configuration to instance preemptible"
  type = object({
    type                 = optional(string, "TERMINATE")
    preserve_boot_volume = optional(bool, false)
  })
  default = {
    type                 = "TERMINATE"
    preserve_boot_volume = false
  }
}

variable "ssh_keys" {
  description = "String with keys SSH, one per line"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Shell script with to run on start of the instance"
  type        = any
  default     = ""
}

variable "quake_bot_level" {
  description = "Quake bot level to instance"
  type        = string
  default     = "Severe"
}

variable "assign_private_dns_record" {
  description = "If true, will be assign private DNS record"
  type        = bool
  default     = true
}

variable "hostname_label" {
  description = "The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname portion of the primary private IP's fully qualified domain name (FQDN) (for example, bminstance1 in FQDN bminstance1.subnet123.vcn1.oraclevcn.com)"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IP number to instance"
  type        = string
  default     = null
}

variable "nsg_ids" {
  description = "NSG IDs"
  type        = list(string)
  default     = null
}

variable "skip_source_dest_check" {
  description = "If true, skip source dest check"
  type        = bool
  default     = null
}

variable "vlan_id" {
  description = "VLAN ID"
  type        = string
  default     = null
}

variable "source_type" {
  description = "Type of source"
  type        = string
  default     = "image"
}

variable "image_ocid" {
  description = "Image ICID of SO to instance"
  type        = string
  default     = null
}

variable "volume_size" {
  description = "Volume size to instance"
  type        = number
  default     = 50
}

variable "boot_volume_vpus_per_gb" {
  description = "VPUS per Giga to boot bolume"
  type        = number
  default     = 10
}

variable "kms_key_id" {
  description = "KMS key ID"
  type        = string
  default     = null
}

variable "recovery_action" {
  description = "The instance is restored to the lifecycle state it was in before the maintenance event, can be RESTORE_INSTANCE or STOP_INSTANCE"
  type        = string
  default     = "RESTORE_INSTANCE"
}

variable "is_live_migration_preferred" {
  description = "If live migration preferred"
  type        = bool
  default     = null
}

variable "are_legacy_imds_endpoints_disabled" {
  description = "If legacy imds endpoints disabled"
  type        = bool
  default     = false
}

variable "is_management_disabled" {
  description = "If management disabled"
  type        = bool
  default     = false
}

variable "are_all_plugins_disabled" {
  description = "If all plugins disabled"
  type        = bool
  default     = null
}

variable "is_monitoring_disabled" {
  description = "If monitoring disabled"
  type        = bool
  default     = false
}

variable "desired_vulnerability_scanning" {
  description = "Desired vulnerability scanning"
  type        = string
  default     = "DISABLED"
}

variable "name_vulnerability_scanning" {
  description = "Name to vulnerability scanning"
  type        = string
  default     = "Vulnerability Scanning"
}

variable "desired_management_agent" {
  description = "Desired management agent"
  type        = string
  default     = "DISABLED"
}

variable "name_management_agent" {
  description = "Name to management agent"
  type        = string
  default     = "Management Agent"
}

variable "desired_logs_monitoring" {
  description = "Desired logs monitoring"
  type        = string
  default     = "ENABLED"
}

variable "name_logs_monitoring" {
  description = "Name to logs monitoring"
  type        = string
  default     = "Custom Logs Monitoring"
}

variable "desired_instance_monitoring" {
  description = "Desired instance monitoring"
  type        = string
  default     = "ENABLED"
}

variable "name_instance_monitoring" {
  description = "Name to instance monitoring"
  type        = string
  default     = "Compute Instance Monitoring"
}

variable "desired_bastion" {
  description = "Desired bastion"
  type        = string
  default     = "DISABLED"
}

variable "name_bastion" {
  description = "Name to bastion"
  type        = string
  default     = "Bastion"
}

variable "agent_plugins_config" {
  description = "List with other plugins to enable"
  type = list(object({
    desired_state = string
    name          = string
  }))
  default = null
}

variable "compute_cluster_id" {
  description = "Compute cluster ID"
  type        = string
  default     = null
}

variable "dedicated_vm_host_id" {
  description = "Dedicated VM host ID"
  type        = string
  default     = null
}

variable "ipxe_script" {
  description = "IPXE script"
  type        = string
  default     = null
}

variable "capacity_reservation_id" {
  description = "Capacity reservation ID"
  type        = string
  default     = null
}

variable "extended_metadata" {
  description = "Extended metadata"
  type = object({
    some_string   = string
    nested_object = string
  })
  default = null
}

variable "launch_options" {
  description = "Launch options"
  type = object({
    boot_volume_type                    = optional(string)
    firmware                            = optional(string)
    is_consistent_volume_naming_enabled = optional(bool)
    is_pv_encryption_in_transit_enabled = optional(bool)
    network_type                        = optional(string)
    remote_data_volume_type             = optional(string)
  })
  default = null
}

variable "platform_config" {
  description = "Platform config"
  type = object({
    type                                           = string
    are_virtual_instructions_enabled               = optional(string)
    is_access_control_service_enabled              = optional(bool)
    is_input_output_memory_management_unit_enabled = optional(bool)
    is_measured_boot_enabled                       = optional(bool)
    is_memory_encryption_enabled                   = optional(bool)
    is_secure_boot_enabled                         = optional(bool)
    is_symmetric_multi_threading_enabled           = optional(bool)
    is_trusted_platform_module_enabled             = optional(bool)
    numa_nodes_per_socket                          = optional(string)
    percentage_of_cores_enabled                    = optional(string)
  })
  default = null
}

variable "has_public_ip" {
  description = "If has public IP"
  type        = bool
  default     = false
}

variable "use_tags_default" {
  description = "If true will be use the tags default to resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to instance"
  type        = map(any)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags to instance"
  type        = map(any)
  default     = null
}

variable "tags_vnic_details" {
  description = "Tags to VNIC details"
  type        = map(any)
  default     = {}
}

variable "defined_tags_vnic_details" {
  description = "Defined tags to VNIC details"
  type        = map(any)
  default     = null
}
