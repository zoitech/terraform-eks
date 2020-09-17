output "oidc_provider_issuer" {
  value = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}
