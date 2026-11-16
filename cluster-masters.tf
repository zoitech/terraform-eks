# EKS Cluster

resource "aws_eks_cluster" "cluster-masters" {
  name                      = var.cluster-name
  version                   = var.master-nodes-k8s-version
  role_arn                  = var.enable_iam ? aws_iam_role.eks-masters[0].arn : var.eks-masters-iam-role
  enabled_cluster_log_types = var.enabled_cluster_log_types

  access_config {
    authentication_mode                         = var.cluster-authentication-mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions

  }

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

  dynamic "encryption_config" {
    for_each = var.enable_cluster_encryption_config ? [var.cluster_encryption_config] : []
    content {
      provider {
        key_arn = aws_kms_key.k8s_secret_key[0].arn
      }
      resources = encryption_config.value.resources
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_security_group_rule.Group-eks-self,
    aws_kms_key_policy.k8s_secret_key
  ]
}
