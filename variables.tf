variable "region" {}
variable "vpc-id" {}
variable "cluster-name" {}
variable "eks-version" {}
variable "nodes-subnets-ids" {}
variable "nodes-ami-release" {}
variable "cluster-subnet-ids" {}
variable "instance-types" {}
variable "nodes-version" {}

variable "nodes-count" {
  default = "1"
}
variable "max-nodes-count" {
  default = "5"
}
variable "min-nodes-count" {
  default = "1"
}
variable "eks-additional-security-groups" {
  default = []
}
variable "nodes-additional-security-groups" {
  default = []
}
variable "enable-private-access" {
  default = true
}
variable "enable-public-access" {
  default = false
}
variable "tags" {
  type = map(string)
}

   