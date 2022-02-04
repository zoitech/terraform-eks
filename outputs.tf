output "oidc_provider_issuer" {
  value = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}

output "cluster-arn" {
  value = aws_eks_cluster.cluster-masters.arn
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
  value       = aws_eks_cluster.cluster-masters.vpc_config[0].cluster_security_group_id
}

output "eks_nodes_role" {
  description = "IAM role used by EKS node group."
  value       = var.enable_iam ? aws_iam_role.nodes[0].arn : var.eks-nodes-iam-role
}

output "eks_nodes_launch_template_id" {
  value = aws_launch_template.cluster-nodes-launch-template.id
}