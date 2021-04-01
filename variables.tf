variable "region" {}
variable "vpc-id" {}
variable "cluster-name" {}
variable "eks-version" {}
variable "nodes-version" {}

variable "nodes-subnets-ids" {
  type    = list(string)
}
variable "cluster-subnet-ids" {
  type    = list(string)
}
variable "instance-types" {
  type = list(string)
}
variable "spot-instance-types" {
  type = list(string)
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
variable "spot-nodes-count" {
  default = "1"
}
variable "spot-max-nodes-count" {
  default = "5"
}
variable "spot-min-nodes-count" {
  default = "1"
}
variable "eks-additional-security-groups" {
  type    = list(string)
  default = []
}
variable "nodes-additional-security-groups" {
  type    = list(string)
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
variable "enable-spot-instances" {
  type = bool
}
   
