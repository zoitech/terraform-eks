## Description

Create an EKS cluster with one NodeGroup

The following Resources will be created:

- EKS masters
- EKS NodeGroups
- IAM Roles for EKS service to create other AWS resources
- Security Groups for communication with the cluster

## Usage

```
module "eks" {
  providers = {
    aws = aws
  }
  source                         = "git::https://git.zoi.de/generic/tf-modules/tf-mod-aws-eks.git"
  region                         = var.region
  cluster-name                   = var.cluster-name
  eks-version                    = var.eks-version
  nodes-version                  = var.nodes-version
  nodes-ami-release              = var.nodes-ami-release
  nodes-count                    = var.nodes-count 
  min-nodes-count                = var.min-nodes-count
  max-nodes-count                = var.max-nodes-count
  instance-types                 = var.instance-types
  vpc-id                         = var.vpc-id
  cluster-subnet-ids             = var.cluster-subnet-ids
  nodes-subnets-ids              = var.nodes-subnets-ids
  eks-additional-security-groups = var.eks-additional-security-groups
  enable-autoscaler-iam          = var.enable-autoscaler-iam
  enable-private-access          = var.enable-private-access
  enable-public-access           = var.enable-public-access
}
```