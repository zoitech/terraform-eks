output "oidc_provider_issuer" {
  value = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}

output "cluster-arn" {
  value = aws_eks_cluster.cluster-masters.arn
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
  value       = element(concat(aws_eks_cluster.cluster-masters[*].vpc_config[0].cluster_security_group_id, list("")), 0)
}

output "eks_nodes_role" {
  description = "IAM role used by EKS node group."
  value       = aws_iam_role.nodes.arn
}
