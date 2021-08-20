variable "region" {}
variable "vpc-id" {}
variable "cluster-name" {}
variable "eks-version" {}
variable "nodes-version" {}

variable "primary-instance-type" {
  type = string
  default = ""
}
variable "cluster-subnets-ids" {
  type = list(string)
}
variable "primary-node-subnets-ids" {
  type = list(string)
  default = []
}
variable "spot-node-subnets-ids" {
  type    = list(string)
  default = []
}
variable "spot-instance-types" {
  type    = list(string)
  default = []
}
variable "primary-nodes-count" {
  type = string
  default = "0"
}
variable "primary-max-nodes-count" {
  type = string
  default = "5"
}
variable "primary-min-nodes-count" {
  type = string
  default = "0"
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
  type    = bool
  default = false
}

#aws-auth  
variable "enable-aws-auth" {
  description = "Needs to be enabled at Cluster creation and allows for the management of the aws-auth configmap for the EKS cluster."
  type        = bool
  default     = false
}

variable "map-roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See readme for example format."
  type        = map(list(string))
  default     = {}
}

variable "map-users" {
  description = "Additional IAM users to add to the aws-auth configmap. See readme for example format."
  type        = map(list(string))
  default     = {}
}
variable "enable-primary-nodegroup" {
  type    = bool
  default = false
}
variable "userdata-file" {
  type = string
  description  = "userdata file path"
  default = ""
}  

variable "create_eks_addons" {
  type        = bool
  description = "Enable EKS managed addons creation. Set to true in new cluster, in previous deployed cluster please analyse"
  default     = true
}