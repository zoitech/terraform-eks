variable "region" {}
variable "cluster-name" {}
variable "eks-version" {
  default = "1.17"
}
variable "nodes-count" {
  default = "1"
}
variable "max-nodes-count" {
  default = "5"
}
variable "min-nodes-count" {
  default = "1"
}
variable "instance-types" {
  default = "t3.micro" # smallest possible as default
}
variable "vpc-id" {}
variable "cluster-subnet-ids" {}
variable "eks-additional-security-groups" {
  default = []
}
variable "nodes-subnets-ids" {}
variable "enable-autoscaler-iam" {
  default = true
}
variable "nodes-version" {
  default = "1.17"
}
variable "nodes-ami-release" {
  default = "1.17.9-20200904"
}
variable "enable-private-access" {
  default = true
}
variable "enable-public-access" {
  default = false
}

#LT for Nodes
variable "block_device_mappings"{
  description = 
  device_name = "/dev/sda1"

  ebs {
    volume_size = 20
  }
}

variable "capacity_reservation_specification"{
  description = 
  capacity_reservation_preference = "open"
}

variable "cpu_options"{
  description = 
    core_count       = 4
    threads_per_core = 2
}

variable "cpu_credits"{
  description =     
  cpu_credits = "standard"
}

variable "ebs_optimized"{
  description = 
  default = true
}

variable "elastic_gpu_specifications"{
  description = 
  type = "test"
}

variable "elastic_inference_accelerator"{
  description = 
      type = "eia1.medium"
}

variable "iam_instance_profile"{
  description = 
  name = ""
}

variable "image_id"{
  description = 
  value = ""
}

variable "instance_initiated_shutdown_behavior"{
  description = 
  default = ""
}

variable "instance_market_options"{
  description = 
  market_type = "spot"
}

variable "var.kerner_id"{
  description = 
  value = ""
}

variable "key_name"{
  description = 
  value = ""
}

variable "license_configuration"{
  description = 
  license_configuration_arn = ""
}

variable "metadata_options"{
  description = 
  http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
}

variable "monitoring"{
  description = 
  enabled = true
}

variable "network_interfaces"{
  description = 
  associate_public_ip_address = true
}

variable "placement"{
  description = 
  availability_zone = "us-west-2a"
}

variable "ram_disk_id"{
  description = 
  value = ""
}

variable "tag_specifications"{
  description = 
  resource_type = "instance"

    tags = {
      #more info on Kaercher tags https://smartbox.kaercher.com/display/CLDM/Tags
      alg = #country ak-de, ak-us, ak-nl 
      app = ""
      appid = ""#kaercher app id
      cm = #not sure if needed
      creation = "" #manual, terraform
      department = ""
      env = ""
      Name = ""
      role = ""
      uptime = ""
      
      

      
}

variable "user_data"{
  description = 
  value = filebase64("${path.module}/example.sh")
}

variable ""{}

variable ""{}

variable ""{}

variable ""{}

variable ""{}

variable ""{
  description = 
}