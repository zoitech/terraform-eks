# EKS Setup Module Terraform

**Version 1.0.2** - [Change Log](CHANGELOG.md)

Terraform code to set up an AWS EKS cluster.

---

## Description

Create an EKS cluster with one NodeGroup

The following Resources will be created:

- EKS masters
- EKS NodeGroups
- IAM Roles for EKS service to create other AWS resources
- Security Groups for communication with the cluster

## Information
Prohibited in Launch Template:
- IAM instance profile under Advanced details
- Subnet under Network interfaces (Add network interface)
- Shutdown behavior and Stop - Hibernate behavior under Advanced details. Retain default Don't include in launch template setting in launch template for both settings.

Prohibited in EKS node group config but need to be added to Launch Template:
- AMI type, if custom AMI is used.
- Disk size under Node Group compute configuration on Set compute and scaling configuration page.
- You can't specify source security groups that are allowed remote access when using a launch template.

## aws-auth configmap management
This feature allows for the management of the aws-auth configmap for the eks cluster, the variable to set it is:
- enable-aws-auth = true

*This needs to be set at cluster creation otherwise it will not work, you cannot manage the aws-auth file from terraform if the cluster was already created and AWS created the file.

e.g of variables for aws-auth:

map-roles = {
  role1arn = ["group1", "system:masters"]
  role2arn = ["group2", "group1"]
}

map-users {
  user1arn = ["system:masters", "group1"]
  user2arn = ["group2", "group3"]
}


## IAM Roles

By default the necessary IAM Roles are created in the cluster setup.
If you like to create the IAM Roles outside of the deployment, then you should set  

**enable_iam** = false

and pass the ARN of the IAM Roles for the Master and Nodes in the variables

**eks-masters-iam-role** = "arn:aws:iam::123456789:role/role_eks_cluster_test-cluster"

**eks-nodes-iam-role** = "arn:aws:iam::987654321:role/role_eks_nodes_test-cluster"


## Cluster Addons

The cluster addons are installed by default.

Is possible to define what version of each module to deploy has shown in the example below,

```
  eks_addon_version_vpc_cni        = "v1.9.0-eksbuild.1"
  eks_addon_version_core_dns       = "v1.8.3-eksbuild.1"
  eks_addon_version_kube_proxy     = "v1.19.6-eksbuild.2"
```

If you don't want to managed the addon in the module, please set

**create_eks_addons** = "false"


## Network configuration

In the Kubernetes network configuration for the cluster, you define the CIDR block to assign Kubernetes service IP addresses, within one of the following private IP address blocks: 10.0.0.0/8, 172.16.0.0.0/12, or 192.168.0.0/16.

The CIDR chosen should be pass in the variable, 

**service_ipv4_cidr** = "192.168.0.0/16"

## Usage

```
module "eks" {
  providers = {
    aws = aws
  }
  source                           = "git::https://dummy.git"
  region                           = var.region
  cluster-name                     = var.cluster-name
  eks-version                      = var.eks-version
  nodes-version                    = var.nodes-version
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
  map-users                        = var.map-users
  map-roles                        = var.map-roles
  create_eks_addons                = var.create_eks_addons
  eks_addon_version_vpc_cni        = var.eks_addon_version_vpc_cni
  eks_addon_version_core_dns       = var.eks_addon_version_core_dns
  eks_addon_version_kube_proxy     = var.eks_addon_version_kube_proxy
  enable_iam                       = var.enable_iam
  eks-masters-iam-role             = var.eks-masters-iam-role
  eks-nodes-iam-role               = var.eks-nodes-iam-role
  service_ipv4_cidr                = var.service_ipv4_cidr

  tags = {              
    owner = "example@zoi.de"
    environment = "test"
  }
}

```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.25.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.core_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc-cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster-masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.spot_cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks-masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.cluster-nodes-launch-template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.Group-eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.Group-eks-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.Group-eks-nodes-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.Group-eks-self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | n/a | `string` | n/a | yes |
| <a name="input_cluster-subnets-ids"></a> [cluster-subnets-ids](#input\_cluster-subnets-ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_create_eks_addons"></a> [create\_eks\_addons](#input\_create\_eks\_addons) | Enable EKS managed addons creation. | `bool` | `true` | no |
| <a name="input_eks-additional-security-groups"></a> [eks-additional-security-groups](#input\_eks-additional-security-groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_eks-masters-iam-role"></a> [eks-masters-iam-role](#input\_eks-masters-iam-role) | n/a | `string` | `""` | no |
| <a name="input_eks-nodes-iam-role"></a> [eks-nodes-iam-role](#input\_eks-nodes-iam-role) | n/a | `string` | `""` | no |
| <a name="input_eks-version"></a> [eks-version](#input\_eks-version) | n/a | `string` | n/a | yes |
| <a name="input_eks_addon_resolve_conflicts_core_dns"></a> [eks\_addon\_resolve\_conflicts\_core\_dns](#input\_eks\_addon\_resolve\_conflicts\_core\_dns) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE | `string` | `"NONE"` | no |
| <a name="input_eks_addon_resolve_conflicts_ebs_csi"></a> [eks\_addon\_resolve\_conflicts\_ebs\_csi](#input\_eks\_addon\_resolve\_conflicts\_ebs\_csi) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE | `string` | `"NONE"` | no |
| <a name="input_eks_addon_resolve_conflicts_kube_proxy"></a> [eks\_addon\_resolve\_conflicts\_kube\_proxy](#input\_eks\_addon\_resolve\_conflicts\_kube\_proxy) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE | `string` | `"NONE"` | no |
| <a name="input_eks_addon_resolve_conflicts_vpc_cni"></a> [eks\_addon\_resolve\_conflicts\_vpc\_cni](#input\_eks\_addon\_resolve\_conflicts\_vpc\_cni) | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE. | `string` | `"NONE"` | no |
| <a name="input_eks_addon_version_core_dns"></a> [eks\_addon\_version\_core\_dns](#input\_eks\_addon\_version\_core\_dns) | Core DNS managed EKS addon version. | `string` | `""` | no |
| <a name="input_eks_addon_version_ebs_csi"></a> [eks\_addon\_version\_ebs\_csi](#input\_eks\_addon\_version\_ebs\_csi) | EBS-CSI managed EKS addon version. | `string` | `""` | no |
| <a name="input_eks_addon_version_kube_proxy"></a> [eks\_addon\_version\_kube\_proxy](#input\_eks\_addon\_version\_kube\_proxy) | Kube proxy managed EKS addon version. | `string` | `""` | no |
| <a name="input_eks_addon_version_vpc_cni"></a> [eks\_addon\_version\_vpc\_cni](#input\_eks\_addon\_version\_vpc\_cni) | VPC-CNI managed EKS addon version. | `string` | `""` | no |
| <a name="input_enable-aws-auth"></a> [enable-aws-auth](#input\_enable-aws-auth) | Needs to be enabled at Cluster creation and allows for the management of the aws\_auth configmap for the EKS cluster. | `bool` | `false` | no |
| <a name="input_enable-primary-nodegroup"></a> [enable-primary-nodegroup](#input\_enable-primary-nodegroup) | n/a | `bool` | `false` | no |
| <a name="input_enable-private-access"></a> [enable-private-access](#input\_enable-private-access) | n/a | `bool` | `true` | no |
| <a name="input_enable-public-access"></a> [enable-public-access](#input\_enable-public-access) | n/a | `bool` | `false` | no |
| <a name="input_enable-spot-instances"></a> [enable-spot-instances](#input\_enable-spot-instances) | n/a | `bool` | `false` | no |
| <a name="input_enable_coredns_addon"></a> [enable\_coredns\_addon](#input\_enable\_coredns\_addon) | Enable CoreDNS AddOn | `bool` | `false` | no |
| <a name="input_enable_iam"></a> [enable\_iam](#input\_enable\_iam) | Deploy IAM Roles in cluster creation. | `bool` | `true` | no |
| <a name="input_map-roles"></a> [map-roles](#input\_map-roles) | Additional IAM roles to add to the aws-auth configmap. See readme for example format. | `map(list(string))` | `{}` | no |
| <a name="input_map-users"></a> [map-users](#input\_map-users) | Additional IAM users to add to the aws-auth configmap. See readme for example format. | `map(list(string))` | `{}` | no |
| <a name="input_nodes-additional-security-groups"></a> [nodes-additional-security-groups](#input\_nodes-additional-security-groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_nodes-version"></a> [nodes-version](#input\_nodes-version) | n/a | `string` | `""` | no |
| <a name="input_primary-instance-type"></a> [primary-instance-type](#input\_primary-instance-type) | n/a | `string` | `""` | no |
| <a name="input_primary-max-nodes-count"></a> [primary-max-nodes-count](#input\_primary-max-nodes-count) | n/a | `string` | `"5"` | no |
| <a name="input_primary-min-nodes-count"></a> [primary-min-nodes-count](#input\_primary-min-nodes-count) | n/a | `string` | `"0"` | no |
| <a name="input_primary-node-subnets-ids"></a> [primary-node-subnets-ids](#input\_primary-node-subnets-ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_primary-nodes-count"></a> [primary-nodes-count](#input\_primary-nodes-count) | n/a | `string` | `"0"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_spot-instance-types"></a> [spot-instance-types](#input\_spot-instance-types) | n/a | `list(string)` | `[]` | no |
| <a name="input_spot-max-nodes-count"></a> [spot-max-nodes-count](#input\_spot-max-nodes-count) | Desired max size os spot instance node group | `number` | `5` | no |
| <a name="input_spot-min-nodes-count"></a> [spot-min-nodes-count](#input\_spot-min-nodes-count) | Desired minimum size os spot instance node group | `number` | `1` | no |
| <a name="input_spot-node-subnets-ids"></a> [spot-node-subnets-ids](#input\_spot-node-subnets-ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_spot-nodes-count"></a> [spot-nodes-count](#input\_spot-nodes-count) | Desired size os spot instance node group | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_userdata-file"></a> [userdata-file](#input\_userdata-file) | userdata file path | `string` | `""` | no |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster-arn"></a> [cluster-arn](#output\_cluster-arn) | n/a |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console. |
| <a name="output_eks_ca"></a> [eks\_ca](#output\_eks\_ca) | n/a |
| <a name="output_eks_endpoint"></a> [eks\_endpoint](#output\_eks\_endpoint) | n/a |
| <a name="output_eks_nodes_launch_template_id"></a> [eks\_nodes\_launch\_template\_id](#output\_eks\_nodes\_launch\_template\_id) | n/a |
| <a name="output_eks_nodes_role"></a> [eks\_nodes\_role](#output\_eks\_nodes\_role) | IAM role used by EKS node group. |
| <a name="output_oidc_provider_issuer"></a> [oidc\_provider\_issuer](#output\_oidc\_provider\_issuer) | n/a |
