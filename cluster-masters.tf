# EKS Cluster

resource "aws_eks_cluster" "cluster-masters" {
  name                      = var.cluster-name
  version                   = var.eks-version
  role_arn                  = aws_iam_role.eks-masters.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = concat([aws_security_group.Group-eks.id], var.eks-additional-security-groups)
    subnet_ids              = var.primary-subnets-ids
    endpoint_private_access = var.enable-private-access
    endpoint_public_access  = var.enable-public-access
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
