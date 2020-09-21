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
