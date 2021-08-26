# EKS Cluster

resource "aws_eks_cluster" "cluster-masters" {
  name                      = var.cluster-name
  version                   = var.eks-version
  role_arn                  = aws_iam_role.eks-masters[0].arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = concat([aws_security_group.Group-eks.id], var.eks-additional-security-groups)
    subnet_ids              = var.cluster-subnets-ids
    endpoint_private_access = var.enable-private-access
    endpoint_public_access  = var.enable-public-access
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }
  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_security_group_rule.Group-eks-self
  ]
}
