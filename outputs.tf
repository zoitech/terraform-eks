output "oidc_provider_issuer" {
  value = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}

output "cluster-arn" {
  value = aws_eks_cluster.cluster-masters.arn
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
  value       = local.cluster_primary_security_group_id
}
