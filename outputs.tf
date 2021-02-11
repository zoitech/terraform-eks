output "oidc_provider_issuer" {
  value = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}

output "cluster-arn" {
  value = aws_eks_cluster.cluster-masters.arn
}