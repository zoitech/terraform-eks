# EKS Setup Module Terraform

**Version 0.1.1** - Added support for node tags with launch template [Change Log](CHANGELOG.md)

**Version 0.1.0** - [Change Log](CHANGELOG.md)

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

## Example of aws-auth mapRoles and mapUsers

variable "map-roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]
}

variable "map-users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

## Usage

```
module "eks" {
  providers = {
    aws = aws
  }
  source                         = "git::https://git.zoi.de/generic/tf-modules/tf-mod-aws-eks.git"
  region                           = var.region
  cluster-name                     = var.cluster-name
  eks-version                      = var.eks-version
  nodes-version                    = var.nodes-version
  nodes-count                      = var.primary-nodes-count 
  min-nodes-count                  = var.primary-min-nodes-count
  max-nodes-count                  = var.primary-max-nodes-count
  instance-types                   = var.instance-types
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
  manage-aws-auth                  = var.manage-aws-auth
  
  map-users = [
    {
        userarn  = "arn:aws:iam::1034144444:role/blahblah"
        username = "naointerressa"
        groups   = ["anygroup"]
    },
    {
        userarn  = data.aws_caller_identity.current.arn
        username = "inputusername:{{SessionName}}"
        groups   = ["system:masters"]
    }
  ]

  map-roles = [
    {
        rolearn  = "arn:aws:iam::032496911465:role/platform-staging-role"
        username = "platform-staging-role{{SessionName}}"
        groups   = ["system:masters"]
    }
  ]

  tags = {              
    owner = "example@zoi.de"
    environment = "test"
  }
}
```
