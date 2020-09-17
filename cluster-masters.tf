# EKS Cluster

resource "aws_eks_cluster" "cluster-masters" {
  name                      = var.cluster-name
  version                   = var.k8s-version
  role_arn                  = aws_iam_role.eks-masters.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids      = concat([aws_security_group.Group-eks.id], var.eks_additional_security_groups)
    subnet_ids              = var.cluster_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
