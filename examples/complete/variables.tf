variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "env" {
  description = "Environment"
  default     = "dev"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "main"
}

#############################################
#               EKS Cluster                 #
#############################################
variable "cluster-name" {
  type        = string
  default     = ""
  description = "Name of the EKS cluster"
}

variable "cluster-authentication-mode" {
  type        = string
  description = "Authentication mode for the EKS cluster"
}

variable "master-nodes-k8s-version" {
  type        = string
  default     = ""
  description = "EKS version of the Master nodes"
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
# Spot instances
variable "enable-spot-instances" {
  type    = bool
  default = false
}
variable "spot-node-subnets-ids" {
  type    = list(string)
  default = []
}
variable "spot-instance-types" {
  type    = list(string)
  default = []
}
variable "spot-nodes-count" {
  description = "Desired size os spot instance node group"
  default     = 1
}
variable "spot-max-nodes-count" {
  description = "Desired max size os spot instance node group"
  default     = 5
}
variable "spot-min-nodes-count" {
  description = "Desired minimum size os spot instance node group"
  default     = 1
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

variable "eks_addon_version_kube_proxy" {
  type        = string
  description = "Kube proxy managed EKS addon version."
  default     = ""
}

variable "eks_addon_resolve_conflicts_kube_proxy" {
  type        = string
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE"
  default     = "OVERWRITE"
}

variable "eks_addon_version_core_dns" {
  type        = string
  description = "Core DNS managed EKS addon version, this is an optional parameter. If not provided, the recommended version will be used according to the K8s version."
  default     = ""
}

variable "eks_addon_resolve_conflicts_core_dns" {
  type        = string
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE"
  default     = "OVERWRITE"
}

variable "enable_vpc_cni_addon" {
  type        = bool
  description = "Enable VPC-CNI AddOn"
  default     = false
}

variable "eks_addon_version_vpc_cni" {
  type        = string
  description = "VPC-CNI managed EKS addon version."
  default     = ""
}

variable "eks_addon_resolve_conflicts_vpc_cni" {
  type        = string
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE."
  default     = "OVERWRITE"
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

variable "eks_addon_version_ebs_csi" {
  type        = string
  description = "EBS-CSI managed EKS addon version."
  default     = ""
}

variable "eks_addon_resolve_conflicts_ebs_csi" {
  type        = string
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE"
  default     = "OVERWRITE"
}

variable "eks_additional_addon_configs" {
  type        = map(any)
  description = "Additional EKS addon configurations."
  default     = {}
}

variable "enable_iam" {
  type        = bool
  description = "Deploy IAM Roles in cluster creation."
  default     = true
}
variable "eks-masters-iam-role" {
  type        = string
  default     = ""
  description = "Pass in an IAM role ARN to use for the EKS masters. If not passed in, a new IAM role will be created."
}
variable "eks-nodes-iam-role" {
  type        = string
  default     = ""
  description = "Pass in an IAM role ARN to use for the EKS nodes. If not passed in, a new IAM role will be created."
}

###################################
#            Addons               #
###################################
#enable addons
variable "enable_fluentbit" {
  description = "enable CloudWatch logging for EKS cluster using fluentbit."
  default     = false
}

#AutoScaler
variable "autoscaler_values" {
  type        = map(string)
  description = "EKS Autoscaler Helm Chart Values"
  default     = {}
}

variable "autoscaler_chart_version" {
  type        = string
  description = "Helm chart version for autoscaler_values"
  default     = ""
}

# Load Balancer Controller
variable "aws_lb_controller_values" {
  type        = map(string)
  description = "AWS Load Balancer Controller Helm Chart Values"
  default     = {}
}

variable "aws_lb_chart_version" {
  type        = string
  description = "Helm chart version for aws_lb_controller_values"
  default     = ""
}

#NGINX
variable "lb_backend_protocol" {
  description = "AWS Load Balancer backend protocol"
  default     = "http"
}
variable "lb_ssl_ports" {
  description = "AWS Load balancer SSL ports"
  default     = "443"
}
variable "lb_connection_idle_timeout" {
  description = "AWS Load Balancer connection idle timeout"
  default     = "120"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN"
  default     = ""
  type        = string
}

# Secrets Manager
variable "secrets_store_csi_driver_values" {
  type        = list(map(string))
  description = "Secrets Store CSI Driver arguments"
  default     = []
}
variable "secrets_store_csi_driver_version" {
  type        = string
  description = "Secrets Store CSI Driver version"
  default     = ""
}
variable "secrets_provider_aws_version" {
  type        = string
  description = "Secrets Provider AWS version"
  default     = ""
}
variable "aws_secrets_manager_namespaces" {
  type        = map(list(string))
  description = "AWS Secrets Manager namespaces. See readme for example format and usage, key is used for namespace and the value will be a list of secret ARNs."
  default     = {}
}
variable "create_k8s_namespaces" {
  type        = list(string)
  description = "Creates a kubernetes namespace. This is needed if you are using the secrets manager and the namespace being deployed doesn't exist."
  default     = []
}

variable "enable-oidc-provider" {
  description = "Enable OIDC provider for the EBS CSI driver"
  type        = bool
  default     = false
}
