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

**eks-masters-iam-role**

**eks-nodes-iam-role**


## Cluster Addons

The cluster addons are installed by default, and the default version of each modules is the follow,

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
