# EKS Setup Module Terraform

**Version 1.0.1** - [Change Log](CHANGELOG.md)

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

## Usage

```
module "eks" {
  providers = {
    aws = aws
  }
  source                         = "git::https://git.zoi.de/generic/tf-modules/tf-mod-aws-eks.git?ref=1.0.1"

  region                           = "eu-central-1"
  cluster-name                     = "test-cluster"
  eks-version                      = "1.20"
  nodes-version                    = "1.20"
  primary-nodes-count              = "1"
  primary-min-nodes-count          = "1"
  primary-max-nodes-count          = "1"
  primary-instance-type            = "t3.small"
  vpc-id                           = "" #required
  cluster-subnets-ids              = [""] #required
  primary-node-subnets-ids         = [""] #required
  spot-node-subnets-ids            = [""]
  eks-additional-security-groups   = []
  enable-private-access            = true
  enable-public-access             = true
  nodes-additional-security-groups = []
  enable-spot-instances            = false
  spot-instance-types              = []
  enable-aws-auth                  = true
  userdata-file                    = "path-to-userdata-file"

  map-users = { 
    "arn:aws:iam::1034144444:user/user1" = ["group1", "group2"]
    "arn:aws:iam::${data.aws_caller_identity.current.id}:user/user2" = ["group1", "group2"]
    }

  map-roles = {
    aws_iam_role.example.arn = ["group1", "group2"]
    "arn:aws:iam::1034144444:role/role2" = ["group1", "group2"]
  }

  tags = {              
    owner = "example@zoi.de"
    environment = "test"
  }
}
```
