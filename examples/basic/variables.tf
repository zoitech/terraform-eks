variable "env" {
  description = "Environment"
  default     = "dev"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed"
}

#############################################
#               EKS Cluster                 #
#############################################
variable "cluster-name" {
  type        = string
  default     = ""
  description = "Name of the EKS cluster"
}
variable "master-nodes-k8s-version" {
  type        = string
  default     = ""
  description = "EKS version of the Master nodes"
}

variable "eks_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs where the EKS cluster will be deployed"

}

variable "eks-additional-security-groups" {
  type        = list(string)
  default     = []
  description = "Additional security groups to attach to the EKS Control Plane/Master nodes"
}
variable "enable-private-access" {
  default     = true
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = string
}
variable "enable-public-access" {
  default     = false
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = string
}
variable "userdata-file" {
  type        = string
  description = "userdata file path"
  default     = ""
}

variable "service_ipv4_cidr" {
  type        = string
  description = "Service IPv4 CIDR"
  default     = "172.20.0.0/16"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to the resources created by the module"
}
# Primary Worker Nodegroup
variable "enable-primary-nodegroup" {
  type        = bool
  default     = false
  description = "Enable the creation of the primary Worker nodegroup"
}
variable "worker-nodes-k8s-version" {
  type        = string
  default     = ""
  description = "EKS version of the Worker nodes. If empty, defaults to master-nodes-k8s-version"
}
variable "nodegroup-instance-types" {
  type        = list(string)
  default     = []
  description = "List of instance types for the nodegroup"
}

variable "primary-nodes-count" {
  type        = string
  default     = "0"
  description = "Desired size of the primary node group"
}
variable "primary-max-nodes-count" {
  type        = string
  default     = "5"
  description = "value of the max size of the primary node group"
}
variable "primary-min-nodes-count" {
  type        = string
  default     = "0"
  description = "value of the min size of the primary node group"
}
variable "nodes-additional-security-groups" {
  type        = list(string)
  default     = []
  description = "Additional security groups to attach to the Worker nodes"
}

#aws-auth
variable "enable-aws-auth" {
  description = "Needs to be enabled at Cluster creation and allows for the management of the aws-auth configmap for the EKS cluster."
  type        = bool
  default     = false
}

variable "map-roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See readme for example format."
  type        = list(any)
  default     = []
}

variable "map-users" {
  description = "Additional IAM users to add to the aws-auth configmap. See readme for example format."
  type        = list(any)
  default     = []
}

# Addons
variable "create_eks_addons" {
  type        = bool
  description = "Enable EKS managed addons creation."
  default     = true
}

variable "enable_kube_proxy_addon" {
  type        = bool
  description = "Enable Kube Proxy AddOn"
  default     = false
}

variable "enable_vpc_cni_addon" {
  type        = bool
  description = "Enable VPC-CNI AddOn"
  default     = false
}

variable "enable_coredns_addon" {
  type        = bool
  description = "Enable CoreDNS AddOn"
  default     = false
}

variable "enable_ebs_csi_addon" {
  type        = bool
  description = "Enable EBS-CSI AddOn"
  default     = false
}

variable "owner_tag" {
  type        = string
  description = "Owner tag to add to the resources created by the module"
  default     = ""
}

variable "enable-oidc-provider" {
  description = "Enable OIDC provider for the EBS CSI driver and IRSA (IAM Roles for Service Accounts)"
  type        = bool
  default     = false
}
