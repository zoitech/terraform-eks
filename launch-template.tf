resource "aws_launch_template" "cluster-nodes-launch-template" {
  name = "cluster-nodes-launch-template"

  block_device_mappings = var.block_device_mappings

  capacity_reservation_specification = var.capacity_reservation_specification

  cpu_options = var.cpu_options
  credit_specification = var.cpu_credits

  ebs_optimized = var.ebs_optimized

  elastic_gpu_specifications = var.elastic_gpu_specifications

  elastic_inference_accelerator = .var.elastic_inference_accelerator

  iam_instance_profile = var.iam_instance_profile
  image_id = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type = var.instance-types

  kernel_id = var.kerner_id

  key_name = var.key_name

  license_specification = var.license_configuration

  metadata_options = var.metadata_options

  monitoring = var.monitoring
  network_interfaces = var.network_interfaces

  placement = var.placement

  ram_disk_id = var.ram_disk_id

  #vpc_security_group_ids = var.eks-additional-security-groups || aws_security_group.Group-eks.id

  tag_specifications = var.tag_specifications 

  user_data = var.user_data
}