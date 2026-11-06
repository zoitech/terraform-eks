variable "vpc-id" {
  type        = string
  description = "Vpc id in which to deploy EKS"
}
#############################################
#               EKS Cluster                 #
#############################################
variable "cluster-name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "master-nodes-k8s-version" {
  type        = string
  description = "Kubernetes version of the EKS master nodes"
}

variable "cluster-authentication-mode" {
  type        = string
  description = "Authentication mode for the EKS cluster, aws-auth ConfigMap is deprecated. Default value is for backward compatibility."
  default     = "API_AND_CONFIG_MAP"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "List of enabled cluster log types for the EKS cluster"
}


variable "cluster-subnets-ids" {
  type        = list(string)
  description = "Subnets in which to deploy EKS Control Plane/Master nodes"
}

variable "eks-additional-security-groups" {
  type        = list(string)
  default     = []
  description = "Additional security groups to attach to the EKS Control Plane/Master nodes"
}

variable "enable-private-access" {
  default     = true
  description = "Whether the Amazon EKS private API server endpoint is enabled. Defaults to 'true'"
  type        = bool
}

variable "enable-public-access" {
  default     = false
  description = "Whether the Amazon EKS public API server endpoint is enabled. Defaults to 'false'"
  type        = bool
}

variable "enable_cluster_encryption_config" {
  description = "Whether to enable Kubernetes Encryption Config for the cluster"
  type        = bool
  default     = false
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}`"
  type        = any
  default = {
    resources = ["secrets"]
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type        = bool
  default     = false
  description = "Bootstrap cluster creator admin permissions. It should be set to true if the authentication mode is CONFIG_MAP, in a new cluster."
}

variable "userdata-file" {
  type        = string
  description = "userdata file path"
  default     = ""
}

variable "service_ipv4_cidr" {
  type        = string
  description = "Kubernetes Service IPv4 CIDR. If not specified, EKS default of 172.20.0.0/16 is used."
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

variable "force_update_version" {
  type        = bool
  default     = false
  description = "Forced update if existing pods are unable to be drained"
}

variable "force_ami_update" {
  type        = string
  default     = "1"
  description = "Change this value to force an AMI update without changing worker-nodes-k8s-version (e.g., for security patches). Increment or change to any different value."
}

variable "nodegroup-instance-types" {
  type        = list(string)
  default     = []
  description = "List of instance types for the nodegroup"
}

variable "primary-node-subnets-ids" {
  type        = list(string)
  default     = []
  description = "Subnets in which to deploy the Worker nodes of the primary nodegroup"
}

variable "primary-nodes-count" {
  type        = number
  default     = 0
  description = "Desired size of the primary node group"
}

variable "primary-max-nodes-count" {
  type        = number
  default     = 5
  description = "value of the max size of the primary node group"
}

variable "primary-min-nodes-count" {
  type        = number
  default     = 0
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
  type        = number
  description = "Desired size of spot instance node group"
  default     = 1
}

variable "spot-max-nodes-count" {
  type        = number
  description = "Desired max size of spot instance node group"
  default     = 5
}

variable "spot-min-nodes-count" {
  type        = number
  description = "Desired minimum size of spot instance node group"
  default     = 1
}

# eks access entries
# https://docs.aws.amazon.com/eks/latest/userguide/access-policy-permissions.html
variable "eks_access_entry_type" {
  type        = string
  description = "Type of access entry to create. Defaults to STANDARD which provides the standard workflow"
  default     = "STANDARD"
}

variable "eks_ns_access_entries" {
  type = map(object({
    principal_arn     = string
    policy_arns       = list(string)
    access_scope_type = string
    namespaces        = optional(list(string))
    kubernetes_groups = optional(list(string))
  }))
  description = "IAM Principals to add to EKS, with multiple policies and access scopes. Each entry can have multiple policy ARNs. 'kubernetes_groups' maps the principal into Kubernetes RBAC groups via the access entry, independent of access_scope_type/namespaces."

  validation {
    condition = alltrue([
      for v in values(var.eks_ns_access_entries) :
      contains(["namespace", "cluster"], v.access_scope_type)
    ])
    error_message = "The 'access_scope_type' must be either 'namespace' or 'cluster'."
  }

  validation {
    condition = alltrue([
      for v in values(var.eks_ns_access_entries) :
      (v.access_scope_type == "namespace" ? v.namespaces != null : v.namespaces == null)
    ])
    error_message = "The 'namespaces' attribute must be set if 'access_scope_type' is 'namespace', and must be null if 'access_scope_type' is 'cluster'."
  }

  validation {
    condition = alltrue([
      for v in values(var.eks_ns_access_entries) :
      length(v.policy_arns) > 0
    ])
    error_message = "The 'policy_arns' list must contain at least one policy ARN."
  }

  default = {}
}

#aws-auth
variable "enable-aws-auth" {
  description = "Enabling aws-auth is a legacy setting, current default is to set Authentication Mode to API and use Access entries. If aws-auth is required, it needs to be enabled at Cluster creation and allows for the management of the aws-auth configmap for the EKS cluster."
  type        = bool
  default     = false
}

variable "aws_auth_labels" {
  description = "Additional labels to add to the aws-auth configmap."
  type        = map(string)
  default     = {}
}

variable "map-roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See readme for example format."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map-users" {
  description = "Additional IAM users to add to the aws-auth configmap. See readme for example format."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
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

variable "coredns_configuration_values" {
  type        = string
  description = "JSON-encoded configurationValues for the CoreDNS EKS addon (e.g. { \"corefile\": \"...\" } to override the default Corefile). Null uses the addon's built-in defaults."
  default     = null
}

# EBS CSI Driver
variable "enable_ebs_csi_addon" {
  description = "enable EBS CSI Driver"
  default     = false
  type        = bool
}

variable "ebs_csi_driver_version" {
  type        = string
  description = "EBS CSI Driver version"
  default     = ""
}

variable "eks_addon_resolve_conflicts_ebs_csi" {
  description = "EBS CSI Driver resolve conflicts"
  default     = "OVERWRITE"
  type        = string
}

variable "enable_iam" {
  type        = bool
  description = "Deploy IAM Roles in cluster creation."
  default     = true
}

variable "eks-masters-iam-role" {
  type        = string
  default     = ""
  description = "Pass in an IAM role ARN to use for the EKS masters. If not passed in, enable_iam must be set to true, so that the IAM Roles will be created."
}

variable "eks-nodes-iam-role" {
  type        = string
  default     = ""
  description = "Pass in an IAM role ARN to use for the EKS nodes. If not passed in, enable_iam must be set to true, so that the IAM Roles will be created."
}
# KMS
variable "secrets_manager_iam_role_arns" {
  description = "List of ARNs of IAM roles that can decrypt secrets, this will be added to the KMS key policy for the cluster secrets encryption."
  default     = []
  type        = list(string)

  validation {
  condition = alltrue([
    for arn in var.secrets_manager_iam_role_arns : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+$", arn))
  ])
  error_message = "All secrets_manager_iam_role_arns entries must be valid IAM Role ARNs."
}

}
variable "kms_policy_admin_arns" {
  type        = list(string)
  description = "List of ARNs of Admins to be added to kms policy. Required when `var.enable_cluster_encryption_config` is true."
  default     = null

  validation {
    condition = (
      var.enable_cluster_encryption_config
      ? (var.kms_policy_admin_arns != null ? length(var.kms_policy_admin_arns) > 0 : false)
      : true
    )
    error_message = "kms_policy_admin_arns must be a non-empty list of ARNs when enable_cluster_encryption_config is true. The IAM principal running the Terraform code will not be added by default, you can add with a data source."
  }

  validation {
    condition = (
      var.kms_policy_admin_arns == null ? true : alltrue([
        for arn in var.kms_policy_admin_arns : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:.+$", arn))
      ])
    )
    error_message = "All kms_policy_admin_arns entries must be valid IAM ARNs (arn:aws:iam::<account_id>:...)."
  }
}
#############################################
#               OIDC                        #
#############################################
variable "eks_svc_account_roles" {
  description = "Add the name of the IAM role, service account and namespace"
  type = map(object({
    role_name      = string
    namespace      = string
    svc_account    = string
    iam_policy_arn = string
  }))
  default = {}
}

variable "enable-oidc-provider" {
  description = "Enable OIDC provider for the EBS CSI driver"
  type        = bool
  default     = false
}

