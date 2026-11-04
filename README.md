# EKS Setup Module Terraform

**Version 1.0.3** - [Change Log](CHANGELOG.md)

Terraform code to set up an AWS EKS cluster.

---

## Description

Create an EKS cluster with one NodeGroup

The following Resources will be created:

- EKS masters
- EKS NodeGroups
- IAM Roles for EKS service to create other AWS resources
- Security Groups for communication with the cluster

Full list of [Resources](#resources)

### Optional Resources
- EKS Addons

## Information
Prohibited in Launch Template:
- IAM instance profile under Advanced details
- Subnet under Network interfaces (Add network interface)
- Shutdown behavior and Stop - Hibernate behavior under Advanced details. Retain default Don't include in launch template setting in launch template for both settings.

Prohibited in EKS node group config but need to be added to Launch Template:
- AMI type, if custom AMI is used.
- Disk size under Node Group compute configuration on Set compute and scaling configuration page.
- You can't specify source security groups that are allowed remote access when using a launch template.

* Rember to add the Helm & K8s providers:
```
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}
```

## aws-auth configmap management
This feature allows for the management of the aws-auth configmap for the eks cluster, the variable to set it is:
- enable-aws-auth = true

* This needs to be set at cluster creation otherwise it will not work, you cannot manage the aws-auth file from terraform if the cluster was already created and AWS created the file.

Variable structure information:
* Rolearn/userarn are the IAM arns for the Role/user that we are attaching the username and groups within k8s.
* Groups, are the groups within k8s.
* username is the username within k8s that the principal will have.
* {{SessionName}} will allow us to use the aws iam session name of the user to add to the username in k8s.

e.g of variables for aws-auth:
```
map-users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test.user"
      groups   = ["system:masters"]
      username = "test1"
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test.two"
      groups   = ["system:masters"]
      username = "test2"
    }
  ]

  map-roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/test-role"
      groups   = ["system:masters"]
      username = "test_admin_{{SessionName}}"
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/test-role-2"
      groups   = ["system:masters"]
      username = "test2_admin_{{SessionName}}"
    }
  ]
```

## IAM Roles

By default the necessary IAM Roles are created in the cluster setup.
If you like to create the IAM Roles outside of the deployment, then you should set

**enable_iam** = false

and pass the ARN of the IAM Roles for the Master and Nodes in the variables

**eks-masters-iam-role** = "arn:aws:iam::123456789:role/role_eks_cluster_test-cluster"

**eks-nodes-iam-role** = "arn:aws:iam::987654321:role/role_eks_nodes_test-cluster"


## Cluster Addons

The cluster addons are installed by default.

Version selection behaviour:

- If an explicit addon version providedvia the module variables (for example `eks_addon_version_vpc_cni`), that version will be used.
- If the addon version variables are empty, the module will attempt to use a recommended default version mapped to the cluster `master-nodes-k8s-version` (see `locals.add_on_versions`).
- If there is no mapped values, the addon `addon_version` will be left unset and AWS will select a recommended version.

Node AMI selection:

- The AMI lookup used for node groups uses an "effective" nodes version. This is `var.worker-nodes-k8s-version` when set, otherwise the module falls back to `var.master-nodes-k8s-version`. The module implements this as `local.effective_nodes_version`. Ensure at least one of `master-nodes-k8s-version` or `worker-nodes-k8s-version` is provided so the AMI SSM parameter lookup resolves correctly.

You can explicitly define what version of each addon to deploy as shown in the example below,

```
  # add-ons
  create_eks_addons                = true

  enable_vpc_cni_addon             = true
  enable_coredns_addon             = true
  enable_ebs_csi_addon             = true
  enable_kube_proxy_addon          = true

  eks_additional_addon_configs = {
  name_of_addon1 = {
    version = "1.0.0"
    resolve_conflicts = "NONE" # Not required, default is OVERWRITE
  },
  name_of_addon2 = {
    version = "1.0.0"
    resolve_conflicts = "NONE" # Not required, default is OVERWRITE
  }
}
```

If you don't want to manage the addons in the module, please set

**create_eks_addons** = "false"


## Network configuration

In the Kubernetes network configuration for the cluster, you define the CIDR block to assign Kubernetes service IP addresses, within one of the following private IP address blocks: 10.0.0.0/8, 172.16.0.0.0/12, or 192.168.0.0/16.

The CIDR chosen should be pass in the variable,

**service_ipv4_cidr** = "192.168.0.0/16"

## Secrets Encryption with KMS
* IAM Roles of IRSAs that need to decrypt secrets in the cluster must be passed in using the secrets_manager_iam_role_arns variable, this will allow the kms decryption.
* Encryption is enabled by default on the cluster.

## Usage

```
module "eks" {
  providers = {
    aws = aws
  }
  source                           = "git::https://github.com/zoitech/terraform-eks"

  region                           = var.region
  cluster-name                     = var.cluster-name
  master-nodes-k8s-version                      = var.master-nodes-k8s-version
  worker-nodes-k8s-version                    = var.worker-nodes-k8s-version
  enable-primary-nodegroup         = var.enable-primary-nodegroup
  primary-nodes-count              = var.primary-nodes-count
  primary-min-nodes-count          = var.primary-min-nodes-count
  primary-max-nodes-count          = var.primary-max-nodes-count
  primary-instance-type            = var.primary-instance-type
  vpc-id                           = var.vpc-id
  cluster-subnets-ids              = var.cluster-subnets-ids
  primary-node-subnets-ids         = var.primary-node-subnets-ids
  spot-node-subnets-ids            = var.spot-node-subnets-ids
  eks-additional-security-groups   = var.eks-additional-security-groups
  enable-private-access            = var.enable-private-access
  enable-public-access             = var.enable-public-access
  nodes-additional-security-groups = var.nodes-additional-security-groups
  enable-spot-instances            = var.enable-spot-instances
  spot-instance-types              = var.spot-instance-types
  spot-nodes-count                 = var.spot-nodes-count
  spot-max-nodes-count             = var.spot-max-nodes-count
  spot-min-nodes-count             = var.spot-min-nodes-count
  userdata-file                    = "path-to-userdata-file"
  enable_iam                       = var.enable_iam
  eks-masters-iam-role             = var.eks-masters-iam-role
  eks-nodes-iam-role               = var.eks-nodes-iam-role
  service_ipv4_cidr                = var.service_ipv4_cidr

  # add-ons
  create_eks_addons                = var.create_eks_addons
  enable_vpc_cni_addon             = var.enable_vpc_cni_addon
  enable_coredns_addon             = var.enable_coredns_addon
  enable_ebs_csi_addon             = var.enable_ebs_csi_addon
  enable_kube_proxy_addon          = var.enable_kube_proxy_addon

  eks_additional_addon_configs = {
    name_of_addon1 = {
      version = ""
      resolve_conflicts = "" # value default is OVERWRITE
    },
    name_of_addon2 = {
      version = ""
      resolve_conflicts = "" # value default is OVERWRITE
    }
  }

  map-users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test.user"
      groups   = ["system:masters"]
      username = "test1"
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test.two"
      groups   = ["system:masters"]
      username = "test2"
    }
  ]

  map-roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/test-role"
      groups   = ["system:masters"]
      username = "test_admin_{{SessionName}}"
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/test-role-2"
      groups   = ["system:masters"]
      username = "test2_admin_{{SessionName}}"
    }
  ]

  tags = {
    owner = "example@test.com"
    environment = "test"
  }
}

# Providers
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

```

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.70.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.4.2 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eks_access_entry.cluster-access-entries](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.cluster_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_addon.core_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster-masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.spot_cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks-oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.access_eks_service_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aws_ebs_csi_driver_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks-masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEBS_CSI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.access_eks_service_account_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.k8s_secret_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.k8s_secret_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.k8s_secret_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_launch_template.cluster-nodes-launch-template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.Group-eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.Group-eks-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.Group-eks-nodes-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.Group-eks-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_config_map_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [terraform_data.node_version_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_addon_version.core_dns_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.ebs_csi_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.kube_proxy_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.vpc_cni_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.eks_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [tls_certificate.cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aws_auth_labels"></a> [aws\_auth\_labels](#input\_aws\_auth\_labels) | Additional labels to add to the aws-auth configmap. | `map(string)` | `{}` | no |
| <a name="input_bootstrap_cluster_creator_admin_permissions"></a> [bootstrap\_cluster\_creator\_admin\_permissions](#input\_bootstrap\_cluster\_creator\_admin\_permissions) | Bootstrap cluster creator admin permissions. It should be set to true if the authentication mode is CONFIG\_MAP, in a new cluster. | `bool` | `false` | no |
| <a name="input_cluster-authentication-mode"></a> [cluster-authentication-mode](#input\_cluster-authentication-mode) | Authentication mode for the EKS cluster, aws-auth ConfigMap is deprecated. Default value is for backward compatibility. | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster-subnets-ids"></a> [cluster-subnets-ids](#input\_cluster-subnets-ids) | Subnets in which to deploy EKS Control Plane/Master nodes | `list(string)` | n/a | yes |
| <a name="input_cluster_encryption_config"></a> [cluster\_encryption\_config](#input\_cluster\_encryption\_config) | Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}` | `any` | <pre>{<br/>  "resources": [<br/>    "secrets"<br/>  ]<br/>}</pre> | no |
| <a name="input_coredns_configuration_values"></a> [coredns\_configuration\_values](#input\_coredns\_configuration\_values) | JSON-encoded configurationValues for the CoreDNS EKS addon (e.g. { "corefile": "..." } to override the default Corefile). Null uses the addon's built-in defaults. | `string` | `null` | no |
| <a name="input_create_eks_addons"></a> [create\_eks\_addons](#input\_create\_eks\_addons) | Enable EKS managed addons creation. | `bool` | `true` | no |
| <a name="input_ebs_csi_driver_version"></a> [ebs\_csi\_driver\_version](#input\_ebs\_csi\_driver\_version) | EBS CSI Driver version | `string` | `""` | no |
| <a name="input_eks-additional-security-groups"></a> [eks-additional-security-groups](#input\_eks-additional-security-groups) | Additional security groups to attach to the EKS Control Plane/Master nodes | `list(string)` | `[]` | no |
| <a name="input_eks-masters-iam-role"></a> [eks-masters-iam-role](#input\_eks-masters-iam-role) | Pass in an IAM role ARN to use for the EKS masters. If not passed in, enable\_iam must be set to true, so that the IAM Roles will be created. | `string` | `""` | no |
| <a name="input_eks-nodes-iam-role"></a> [eks-nodes-iam-role](#input\_eks-nodes-iam-role) | Pass in an IAM role ARN to use for the EKS nodes. If not passed in, enable\_iam must be set to true, so that the IAM Roles will be created. | `string` | `""` | no |
| <a name="input_eks_access_entry_type"></a> [eks\_access\_entry\_type](#input\_eks\_access\_entry\_type) | Type of access entry to create. Defaults to STANDARD which provides the standard workflow | `string` | `"STANDARD"` | no |
| <a name="input_eks_addon_resolve_conflicts_core_dns"></a> [eks\_addon\_resolve\_conflicts\_core\_dns](#input\_eks\_addon\_resolve\_conflicts\_core\_dns) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_addon_resolve_conflicts_ebs_csi"></a> [eks\_addon\_resolve\_conflicts\_ebs\_csi](#input\_eks\_addon\_resolve\_conflicts\_ebs\_csi) | EBS CSI Driver resolve conflicts | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_addon_resolve_conflicts_kube_proxy"></a> [eks\_addon\_resolve\_conflicts\_kube\_proxy](#input\_eks\_addon\_resolve\_conflicts\_kube\_proxy) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_addon_resolve_conflicts_vpc_cni"></a> [eks\_addon\_resolve\_conflicts\_vpc\_cni](#input\_eks\_addon\_resolve\_conflicts\_vpc\_cni) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE. | `string` | `"OVERWRITE"` | no |
| <a name="input_eks_addon_version_core_dns"></a> [eks\_addon\_version\_core\_dns](#input\_eks\_addon\_version\_core\_dns) | Core DNS managed EKS addon version, this is an optional parameter. If not provided, the recommended version will be used according to the K8s version. | `string` | `""` | no |
| <a name="input_eks_addon_version_kube_proxy"></a> [eks\_addon\_version\_kube\_proxy](#input\_eks\_addon\_version\_kube\_proxy) | Kube proxy managed EKS addon version. | `string` | `""` | no |
| <a name="input_eks_addon_version_vpc_cni"></a> [eks\_addon\_version\_vpc\_cni](#input\_eks\_addon\_version\_vpc\_cni) | VPC-CNI managed EKS addon version. | `string` | `""` | no |
| <a name="input_eks_ns_access_entries"></a> [eks\_ns\_access\_entries](#input\_eks\_ns\_access\_entries) | IAM Principals to add to EKS, with multiple policies and access scopes. Each entry can have multiple policy ARNs. 'kubernetes\_groups' maps the principal into Kubernetes RBAC groups via the access entry, independent of access\_scope\_type/namespaces. | <pre>map(object({<br/>    principal_arn     = string<br/>    policy_arns       = list(string)<br/>    access_scope_type = string<br/>    namespaces        = optional(list(string))<br/>    kubernetes_groups = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_eks_svc_account_roles"></a> [eks\_svc\_account\_roles](#input\_eks\_svc\_account\_roles) | Add the name of the IAM role, service account and namespace | <pre>map(object({<br/>    role_name      = string<br/>    namespace      = string<br/>    svc_account    = string<br/>    iam_policy_arn = string<br/>  }))</pre> | `{}` | no |
| <a name="input_enable-aws-auth"></a> [enable-aws-auth](#input\_enable-aws-auth) | Enabling aws-auth is a legacy setting, current default is to set Authentication Mode to API and use Access entries. If aws-auth is required, it needs to be enabled at Cluster creation and allows for the management of the aws-auth configmap for the EKS cluster. | `bool` | `false` | no |
| <a name="input_enable-oidc-provider"></a> [enable-oidc-provider](#input\_enable-oidc-provider) | Enable OIDC provider for the EBS CSI driver | `bool` | `false` | no |
| <a name="input_enable-primary-nodegroup"></a> [enable-primary-nodegroup](#input\_enable-primary-nodegroup) | Enable the creation of the primary Worker nodegroup | `bool` | `false` | no |
| <a name="input_enable-private-access"></a> [enable-private-access](#input\_enable-private-access) | Whether the Amazon EKS private API server endpoint is enabled. Defaults to 'true' | `bool` | `true` | no |
| <a name="input_enable-public-access"></a> [enable-public-access](#input\_enable-public-access) | Whether the Amazon EKS public API server endpoint is enabled. Defaults to 'false' | `bool` | `false` | no |
| <a name="input_enable-spot-instances"></a> [enable-spot-instances](#input\_enable-spot-instances) | Spot instances | `bool` | `false` | no |
| <a name="input_enable_cluster_encryption_config"></a> [enable\_cluster\_encryption\_config](#input\_enable\_cluster\_encryption\_config) | Whether to enable Kubernetes Encryption Config for the cluster | `bool` | `false` | no |
| <a name="input_enable_coredns_addon"></a> [enable\_coredns\_addon](#input\_enable\_coredns\_addon) | Enable CoreDNS AddOn | `bool` | `false` | no |
| <a name="input_enable_ebs_csi_addon"></a> [enable\_ebs\_csi\_addon](#input\_enable\_ebs\_csi\_addon) | enable EBS CSI Driver | `bool` | `false` | no |
| <a name="input_enable_iam"></a> [enable\_iam](#input\_enable\_iam) | Deploy IAM Roles in cluster creation. | `bool` | `true` | no |
| <a name="input_enable_kube_proxy_addon"></a> [enable\_kube\_proxy\_addon](#input\_enable\_kube\_proxy\_addon) | Enable Kube Proxy AddOn | `bool` | `false` | no |
| <a name="input_enable_vpc_cni_addon"></a> [enable\_vpc\_cni\_addon](#input\_enable\_vpc\_cni\_addon) | Enable VPC-CNI AddOn | `bool` | `false` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | List of enabled cluster log types for the EKS cluster | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_force_ami_update"></a> [force\_ami\_update](#input\_force\_ami\_update) | Change this value to force an AMI update without changing worker-nodes-k8s-version (e.g., for security patches). Increment or change to any different value. | `string` | `"1"` | no |
| <a name="input_force_update_version"></a> [force\_update\_version](#input\_force\_update\_version) | Forced update if existing pods are unable to be drained | `bool` | `false` | no |
| <a name="input_kms_policy_admin_arns"></a> [kms\_policy\_admin\_arns](#input\_kms\_policy\_admin\_arns) | List of ARNs of Admins to be added to kms policy | `list(string)` | `[]` | no |
| <a name="input_map-roles"></a> [map-roles](#input\_map-roles) | Additional IAM roles to add to the aws-auth configmap. See readme for example format. | <pre>list(object({<br/>    rolearn  = string<br/>    username = string<br/>    groups   = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_map-users"></a> [map-users](#input\_map-users) | Additional IAM users to add to the aws-auth configmap. See readme for example format. | <pre>list(object({<br/>    userarn  = string<br/>    username = string<br/>    groups   = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_master-nodes-k8s-version"></a> [master-nodes-k8s-version](#input\_master-nodes-k8s-version) | Kubernetes version of the EKS master nodes | `string` | n/a | yes |
| <a name="input_nodegroup-instance-types"></a> [nodegroup-instance-types](#input\_nodegroup-instance-types) | List of instance types for the nodegroup | `list(string)` | `[]` | no |
| <a name="input_nodes-additional-security-groups"></a> [nodes-additional-security-groups](#input\_nodes-additional-security-groups) | Additional security groups to attach to the Worker nodes | `list(string)` | `[]` | no |
| <a name="input_primary-max-nodes-count"></a> [primary-max-nodes-count](#input\_primary-max-nodes-count) | value of the max size of the primary node group | `number` | `5` | no |
| <a name="input_primary-min-nodes-count"></a> [primary-min-nodes-count](#input\_primary-min-nodes-count) | value of the min size of the primary node group | `number` | `0` | no |
| <a name="input_primary-node-subnets-ids"></a> [primary-node-subnets-ids](#input\_primary-node-subnets-ids) | Subnets in which to deploy the Worker nodes of the primary nodegroup | `list(string)` | `[]` | no |
| <a name="input_primary-nodes-count"></a> [primary-nodes-count](#input\_primary-nodes-count) | Desired size of the primary node group | `number` | `0` | no |
| <a name="input_secrets_manager_iam_role_arns"></a> [secrets\_manager\_iam\_role\_arns](#input\_secrets\_manager\_iam\_role\_arns) | List of ARNs of IAM roles that can decrypt secrets, this will be added to the KMS key policy for the cluster secrets encryption. | `list(string)` | `[]` | no |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | Kubernetes Service IPv4 CIDR. If not specified, EKS default of 172.20.0.0/16 is used. | `string` | `"172.20.0.0/16"` | no |
| <a name="input_spot-instance-types"></a> [spot-instance-types](#input\_spot-instance-types) | n/a | `list(string)` | `[]` | no |
| <a name="input_spot-max-nodes-count"></a> [spot-max-nodes-count](#input\_spot-max-nodes-count) | Desired max size of spot instance node group | `number` | `5` | no |
| <a name="input_spot-min-nodes-count"></a> [spot-min-nodes-count](#input\_spot-min-nodes-count) | Desired minimum size of spot instance node group | `number` | `1` | no |
| <a name="input_spot-node-subnets-ids"></a> [spot-node-subnets-ids](#input\_spot-node-subnets-ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_spot-nodes-count"></a> [spot-nodes-count](#input\_spot-nodes-count) | Desired size of spot instance node group | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources created by the module | `map(string)` | `{}` | no |
| <a name="input_userdata-file"></a> [userdata-file](#input\_userdata-file) | userdata file path | `string` | `""` | no |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | Vpc id in which to deploy EKS | `string` | n/a | yes |
| <a name="input_worker-nodes-k8s-version"></a> [worker-nodes-k8s-version](#input\_worker-nodes-k8s-version) | EKS version of the Worker nodes. If empty, defaults to master-nodes-k8s-version | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster-arn"></a> [cluster-arn](#output\_cluster-arn) | The Amazon Resource Name (ARN) of the cluster. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The base64 encoded certificate data required to communicate with your cluster. Add this to the 'certificate-authority-data' section of the kubeconfig file for your cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for your Kubernetes API server. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster. |
| <a name="output_cluster_oidc_provider_issuer"></a> [cluster\_oidc\_provider\_issuer](#output\_cluster\_oidc\_provider\_issuer) | Default oidc provider issuer that is created by the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console. |
| <a name="output_eks_nodes_role"></a> [eks\_nodes\_role](#output\_eks\_nodes\_role) | IAM role used by EKS node group. |
| <a name="output_eks_nodes_role_name"></a> [eks\_nodes\_role\_name](#output\_eks\_nodes\_role\_name) | IAM role used by EKS node group. |
| <a name="output_secondary_oidc_provider_arn"></a> [secondary\_oidc\_provider\_arn](#output\_secondary\_oidc\_provider\_arn) | ARN of the secondary OIDC provider that is created by enabling var.enable-oidc-provider. Used for IRSA (IAM Roles for Service Accounts) and EBS CSI. |
| <a name="output_secondary_oidc_provider_url"></a> [secondary\_oidc\_provider\_url](#output\_secondary\_oidc\_provider\_url) | URL of the secondary OIDC provider that is created by enabling var.enable-oidc-provider. Used for IRSA (IAM Roles for Service Accounts) and EBS CSI. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->

