provider "kubernetes" {
  host                   = aws_eks_cluster.cluster-masters.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster-masters.certificate_authority.0.data)
  token                  = aws_eks_cluster_auth.cluster-masters.token
  load_config_file       = false
}