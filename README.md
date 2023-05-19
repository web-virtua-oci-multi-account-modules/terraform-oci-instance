# OCI Instance for multiples accounts with Terraform module
* This module simplifies creating and configuring of Instance across multiple accounts on OCI

* Is possible use this module with one account using the standard profile or multi account using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Criate file provider.tf with the exemple code below:
```hcl
provider "oci" {
  alias   = "alias_profile_a"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}

provider "oci" {
  alias   = "alias_profile_b"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}
```


## Features enable of Instance configurations for this module:

- Instance

## Usage exemples


### Create instance on demand with public IP and template file
```hcl
module "vm_test" {
  source = "web-virtua-oci-multi-account-modules/instance/oci"

  availability_domain = data.oci_identity_availability_domain.ad1.name
  fault_domain        = var.fault_domaim
  compartment_id      = var.compartment_id
  shape               = var.shape
  name                = "tf-vm-test"
  ssh_keys            = var.ssh_keys
  subnet_id           = var.sububnet
  private_ip          = "10.1.1.10"
  has_public_ip       = true
  volume_size         = 50
  image_ocid          = var.ubuntu_image_ocid

  user_data = templatefile("${path.module}/template_files/postgres.tpl", {
    postgres_version = "14"
  })

  shape_config = {
    memory_in_gbs = 2
    ocpus         = 1
  }

  providers = {
    oci = oci.alias_profile_a
  }
}
```

### Create instance preemptible
```hcl
module "vm_test_preemptible" {
  source = "web-virtua-oci-multi-account-modules/instance/oci"

  availability_domain        = data.oci_identity_availability_domain.ad1.name
  fault_domain               = var.fault_domains
  compartment_id             = var.compartment_id
  shape                      = var.shape
  name                       = "tf-vm-test-preemptible"
  ssh_keys                   = var.ssh_keys
  subnet_id                  = var.sububnet
  private_ip                 = "10.1.1.10"
  has_public_ip              = true
  volume_size                = 50
  image_ocid                 = var.ubuntu_image_ocid
  is_preemptible             = true
  assign_public_ip_ephemeral = true

  shape_config = {
    memory_in_gbs = 2
    ocpus         = 1
  }

  providers = {
    oci = oci.alias_profile_a
  }
}
```


## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Instance name | `-` |
| subnet_id | `string` | `-` | yes | Subnet ID to VM | `-` |
| availability_domain | `string` | `null` | no | Availability domain, ex: Uocm:PHX-AD-1 | `-` |
| compartment_id | `string` | `null` | no | Compartment ID | `-` |
| compartment_name | `string` | `null` | no | Compartment name | `-` |
| fault_domain | `string` | `FAULT-DOMAIN-1` | no | Fault domain | `-` |
| shape | `string` | `VM.Standard4.Flex` | no | Shape of instance, doc: https://docs.oracle.com/en-us/iaas/api/#/en/iaas/20160918/Shape/ListShapes | `-` |
| preserve_boot_volume | `bool` | `false` | no | If true, will be preserved the instance | `*`false <br> `*`true |
| is_pv_encryption_in_transit_enabled | `bool` | `true` | no | If true, the encryption is enable | `*`false <br> `*`true |
| shape_config | `object` | `null` | no | Configuration to shape flexible | `-` |
| is_preemptible | `bool` | `false` | no | If true the instance will be preemptible | `*`false <br> `*`true |
| preemptible_instance_config | `object` | `object` | no | Configuration to instance preemptible | `-` |
| ssh_keys | `string` | `null` | no | String with keys SSH, one per line | `-` |
| user_data | `any` | `-` | no | Shell script with to run on start of the instance | `-` |
| quake_bot_level | `string` | `Severe` | no | Quake bot level to instance | `-` |
| assign_private_dns_record | `bool` | `true` | no | If true, will be assign private DNS record | `*`false <br> `*`true |
| hostname_label | `string` | `null` | no | The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname portion of the primary private IP's fully qualified domain name (FQDN) (for example, bminstance1 in FQDN bminstance1.subnet123.vcn1.oraclevcn.com) | `-` |
| private_ip | `string` | `null` | no | Private IP number to instance | `-` |
| nsg_ids | `list(string)` | `null` | no | NSG IDs | `-` |
| skip_source_dest_check | `bool` | `null` | no | If true, skip source dest check | `*`false <br> `*`true |
| vlan_id | `string` | `null` | no | VLAN ID | `-` |
| source_type | `string` | `image` | no | Type of source | `-` |
| image_ocid | `string` | `null` | no | Image ICID of SO to instance | `-` |
| volume_size | `number` | `50` | no | Volume size to instance | `-` |
| boot_volume_vpus_per_gb | `number` | `10` | no | VPUS per Giga to boot bolume | `-` |
| kms_key_id | `string` | `null` | no | KMS key ID | `-` |
| recovery_action | `string` | `RESTORE_INSTANCE` | no | The instance is restored to the lifecycle state it was in before the maintenance event, can be RESTORE_INSTANCE or STOP_INSTANCE | `-` |
| is_live_migration_preferred | `bool` | `null` | no | If live migration preferred | `*`false <br> `*`true |
| are_legacy_imds_endpoints_disabled | `bool` | `false` | no | If legacy imds endpoints disabled | `*`false <br> `*`true |
| is_management_disabled | `bool` | `false` | no | If management disabled | `*`false <br> `*`true |
| are_all_plugins_disabled | `bool` | `null` | no | If all plugins disabled | `*`false <br> `*`true |
| is_monitoring_disabled | `bool` | `null` | no | If monitoring disabled | `*`false <br> `*`true |
| desired_vulnerability_scanning | `string` | `DISABLED` | no | Desired vulnerability scanning | `-` |
| name_vulnerability_scanning | `string` | `Vulnerability Scanning` | no | Name to vulnerability scanning | `-` |
| desired_management_agent | `string` | `DISABLED` | no | Desired management agent | `-` |
| name_management_agent | `string` | `Management Agent` | no | Name to management agent | `-` |
| desired_logs_monitoring | `string` | `ENABLED` | no | Desired logs monitoring | `-` |
| name_logs_monitoring | `string` | `Custom Logs Monitoring` | no | Name to logs monitoring | `-` |
| desired_instance_monitoring | `string` | `ENABLED` | no | Desired instance monitoring | `-` |
| name_instance_monitoring | `string` | `Compute Instance Monitoring` | no | Name to instance monitoring | `-` |
| desired_bastion | `string` | `DISABLED` | no | Desired bastion | `-` |
| name_bastion | `string` | `Bastion` | no | Name to bastion | `-` |
| agent_plugins_config | `list(object)` | `null` | no | List with other plugins to enable | `-` |
| compute_cluster_id | `string` | `null` | no | Compute cluster ID | `-` |
| dedicated_vm_host_id | `string` | `null` | no | Dedicated VM host ID | `-` |
| ipxe_script | `string` | `null` | no | IPXE script | `-` |
| capacity_reservation_id | `string` | `null` | no | Capacity reservation ID | `-` |
| extended_metadata | `object` | `null` | no | Extended metadata | `-` |
| launch_options | `object` | `null` | no | Launch options | `-` |
| platform_config | `object` | `null` | no | Platform config | `-` |
| has_public_ip | `bool` | `false` | no | If has public IP | `*`false <br> `*`true |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to resources | `*`false <br> `*`true |
| tags | `map(any)` | `{}` | no | Tags to subnet | `-` |
| defined_tags | `map(any)` | `{}` | no | Defined tags to subnet | `-` |
| tags_vnic_details | `map(any)` | `{}` | no | Tags to VNIC details | `-` |
| defined_tags_vnic_details | `map(any)` | `{}` | no | Defined tags to VNIC details | `-` |

* Default shape_config variable
```hcl
variable "shape_config" {
  description = "Configuration to shape flexible"
  type = object({
    memory_in_gbs             = number
    ocpus                     = number
    nvmes                     = optional(number)
    baseline_ocpu_utilization = optional(string)
  })
  default = {
    memory_in_gbs = 2
    ocpus         = 1
  }
}
```

* Default preemptible_instance_config variable
```hcl
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
```

* Default agent_plugins_config variable
```hcl
variable "agent_plugins_config" {
  description = "List with other plugins to enable"
  type = list(object({
    desired_state = string
    name          = string
  }))
  default = []
}
```

* Default launch_options variable
```hcl
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
  default = {}
}
```

* Default platform_config variable
```hcl
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
  default = {}
}
```


## Resources

| Name | Type |
|------|------|
| [oci_core_instance.create_vm](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `instance` | Instance |
| `instance_id` | Instance ID |
| `boot_volume_id` | Boot volume ID |
| `public_ip` | Public IP |
| `private_ip` | Private IP |
| `private_ip_id` | Private IP ID of instance |
