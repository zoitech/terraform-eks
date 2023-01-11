variable "region" {
  type = string
}

variable "vpc-id" {
  type = string
}

variable "cluster-name" {
  type = string
}

variable "eks-version" {
  type = string
}

variable "nodes-version" {
  type    = string
  default = ""
}

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
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}

variable "enable-spot-instances" {
  type    = bool
  default = false
}

variable "spot-nodes-count" {
  type        = number
  description = "Desired size os spot instance node group"
  default     = 1
}

variable "spot-max-nodes-count" {
  type        = number
  description = "Desired max size os spot instance node group"
  default     = 5
}

variable "spot-min-nodes-count" {
  type        = number
  description = "Desired minimum size os spot instance node group"
  default     = 1
}

variable "enable-aws-auth" {
  type        = bool
  description = "Needs to be enabled at Cluster creation and allows for the management of the aws_auth configmap for the EKS cluster."
  default     = false
}

variable "map-roles" {
  type        = map(list(string))
  description = "Additional IAM roles to add to the aws-auth configmap. See readme for example format."
  default     = {}
}

variable "map-users" {
  type        = map(list(string))
  description = "Additional IAM users to add to the aws-auth configmap. See readme for example format."
  default     = {}
}

variable "enable-primary-nodegroup" {
  type    = bool
  default = false
}

variable "userdata-file" {
  type        = string
  description = "userdata file path"
  default     = ""
}

variable "service_ipv4_cidr" {
  type = string
}

variable "create_eks_addons" {
  type        = bool
  description = "Enable EKS managed addons creation."
  default     = true
}

variable "eks_addon_version_kube_proxy" {
  type        = string
  description = "Kube proxy managed EKS addon version."
  default     = ""
}

variable "eks_addon_version_core_dns" {
  type        = string
  description = "Core DNS managed EKS addon version."
  default     = ""
}

variable "eks_addon_version_vpc_cni" {
  type        = string
  description = "VPC-CNI managed EKS addon version."
  default     = ""
}

variable "enable_coredns_addon" {
  type        = bool
  description = "Enable CoreDNS AddOn"
  default     = false
}

variable "enable_iam" {
  type        = bool
  description = "Deploy IAM Roles in cluster creation."
  default     = true
}

variable "eks-masters-iam-role" {
  type    = string
  default = ""
}

variable "eks-nodes-iam-role" {
  type    = string
  default = ""
}
