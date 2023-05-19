locals {
  tags_instance = {
    "tf-name"        = var.name
    "tf-type"        = "instance"
    "tf-compartment" = var.compartment_name
  }
}

resource "oci_core_instance" "create_vm" {
  display_name                        = var.name
  compartment_id                      = var.compartment_id
  availability_domain                 = var.availability_domain
  fault_domain                        = var.fault_domain
  shape                               = var.shape
  preserve_boot_volume                = var.preserve_boot_volume
  is_pv_encryption_in_transit_enabled = var.is_pv_encryption_in_transit_enabled
  freeform_tags                       = merge(var.tags, var.use_tags_default ? local.tags_instance : {})
  defined_tags                        = var.defined_tags
  compute_cluster_id                  = var.compute_cluster_id
  dedicated_vm_host_id                = var.dedicated_vm_host_id
  ipxe_script                         = var.ipxe_script
  capacity_reservation_id             = var.capacity_reservation_id
  extended_metadata                   = var.extended_metadata

  dynamic "shape_config" {
    for_each = var.shape_config != null ? [1] : []

    content {
      memory_in_gbs             = var.shape_config.memory_in_gbs
      ocpus                     = var.shape_config.ocpus
      nvmes                     = var.shape_config.nvmes
      baseline_ocpu_utilization = var.shape_config.baseline_ocpu_utilization
    }
  }

  dynamic "preemptible_instance_config" {
    for_each = var.is_preemptible ? [1] : []

    content {
      preemption_action {
        type                 = var.preemptible_instance_config.type
        preserve_boot_volume = var.preemptible_instance_config.preserve_boot_volume
      }
    }
  }

  metadata = {
    ssh_authorized_keys = var.ssh_keys
    quake_bot_level     = var.quake_bot_level
    user_data           = base64encode(var.user_data)
  }

  create_vnic_details {
    display_name              = "${var.name}-vnic"
    subnet_id                 = var.subnet_id
    assign_public_ip          = var.has_public_ip
    assign_private_dns_record = var.assign_private_dns_record
    hostname_label            = var.hostname_label != null ? var.hostname_label : "${var.name}-vnic"
    private_ip                = var.private_ip
    defined_tags              = var.defined_tags_vnic_details
    nsg_ids                   = var.nsg_ids
    skip_source_dest_check    = var.skip_source_dest_check
    vlan_id                   = var.vlan_id

    freeform_tags = merge(var.tags_vnic_details, var.use_tags_default ? {
      "tf-name"        = "${var.name}-vnic"
      "tf-main"        = "instance"
      "tf-type"        = "vnic-details"
      "tf-compartment" = var.compartment_name
    } : {})
  }

  source_details {
    source_type             = var.source_type
    source_id               = var.image_ocid
    boot_volume_size_in_gbs = var.volume_size
    boot_volume_vpus_per_gb = var.boot_volume_vpus_per_gb
    kms_key_id              = var.kms_key_id
  }

  availability_config {
    recovery_action             = var.recovery_action
    is_live_migration_preferred = var.is_live_migration_preferred
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = var.are_legacy_imds_endpoints_disabled
  }

  agent_config {
    is_management_disabled   = var.is_management_disabled
    is_monitoring_disabled   = var.is_monitoring_disabled
    are_all_plugins_disabled = var.are_all_plugins_disabled

    plugins_config {
      desired_state = var.desired_vulnerability_scanning
      name          = var.name_vulnerability_scanning
    }

    plugins_config {
      desired_state = var.desired_management_agent
      name          = var.name_management_agent
    }

    plugins_config {
      desired_state = var.desired_logs_monitoring
      name          = var.name_logs_monitoring
    }

    plugins_config {
      desired_state = var.desired_instance_monitoring
      name          = var.name_instance_monitoring
    }

    plugins_config {
      desired_state = var.desired_bastion
      name          = var.name_bastion
    }

    dynamic "plugins_config" {
      for_each = var.agent_plugins_config != null ? var.agent_plugins_config : []

      content {
        desired_state = plugins_config.value.desired_state
        name          = plugins_config.value.name
      }
    }
  }

  dynamic "launch_options" {
    for_each = var.launch_options != null ? [1] : []

    content {
      boot_volume_type                    = var.instance_launch_options_boot_volume_type
      firmware                            = var.instance_launch_options_firmware
      is_consistent_volume_naming_enabled = var.instance_launch_options_is_consistent_volume_naming_enabled
      is_pv_encryption_in_transit_enabled = var.instance_launch_options_is_pv_encryption_in_transit_enabled
      network_type                        = var.instance_launch_options_network_type
      remote_data_volume_type             = var.instance_launch_options_remote_data_volume_type
    }
  }

  dynamic "platform_config" {
    for_each = var.platform_config != null ? [1] : []

    content {
      type                                           = var.instance_platform_config_type
      are_virtual_instructions_enabled               = var.instance_platform_config_are_virtual_instructions_enabled
      is_access_control_service_enabled              = var.instance_platform_config_is_access_control_service_enabled
      is_input_output_memory_management_unit_enabled = var.instance_platform_config_is_input_output_memory_management_unit_enabled
      is_measured_boot_enabled                       = var.instance_platform_config_is_measured_boot_enabled
      is_memory_encryption_enabled                   = var.instance_platform_config_is_memory_encryption_enabled
      is_secure_boot_enabled                         = var.instance_platform_config_is_secure_boot_enabled
      is_symmetric_multi_threading_enabled           = var.instance_platform_config_is_symmetric_multi_threading_enabled
      is_trusted_platform_module_enabled             = var.instance_platform_config_is_trusted_platform_module_enabled
      numa_nodes_per_socket                          = var.instance_platform_config_numa_nodes_per_socket
      percentage_of_cores_enabled                    = var.instance_platform_config_percentage_of_cores_enabled
    }
  }
}
