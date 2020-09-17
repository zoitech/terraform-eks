variable "region" {}
variable "cluster-name" {}
variable "eks-version" {}
variable "nodes-count" {}
variable "max-nodes-count" {}
variable "min-nodes-count" {}
variable "instance-types" {}
variable "vpc-id" {}
variable "cluster-subnet-ids" {}
variable "eks-additional-security-groups" {
  default = []
}
variable "nodes-subnets-ids" {}
variable "enable-autoscaler-iam" {}
variable "nodes-version" {}
variable "nodes-ami-release" {}
