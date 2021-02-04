variable "region" {}
variable "cluster-name" {}
variable "eks-version" {}
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
variable "nodes-ami-release" {}
variable "enable-private-access" {
  default = true
}
variable "enable-public-access" {
  default = false
}

variable "master-tags" {
  type = map(string)
}

variable "node-tags"{
  type = map(string)
}
   