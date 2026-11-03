output "cluster_oidc_provider_issuer" {
  value       = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
  description = "Default oidc provider issuer that is created by the cluster"
}

output "cluster-arn" {
  value       = aws_eks_cluster.cluster-masters.arn
  description = "The Amazon Resource Name (ARN) of the cluster."
}

output "cluster_name" {
  value       = aws_eks_cluster.cluster-masters.name
  description = "The name of the EKS cluster."
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
  value       = aws_eks_cluster.cluster-masters.vpc_config[0].cluster_security_group_id
}
output "cluster_endpoint" {
  value       = aws_eks_cluster.cluster-masters.endpoint
  description = "The endpoint for your Kubernetes API server."
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.cluster-masters.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with your cluster. Add this to the 'certificate-authority-data' section of the kubeconfig file for your cluster."
}

output "eks_nodes_role" {
  description = "IAM role used by EKS node group."
  value       = var.enable_iam ? aws_iam_role.nodes[0].arn : var.eks-nodes-iam-role
}

output "eks_nodes_role_name" {
  description = "IAM role used by EKS node group."
  value       = var.enable_iam ? aws_iam_role.nodes[0].name : trimprefix(var.eks-nodes-iam-role, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/")
}

output "secondary_oidc_provider_url" {
  value       = try(aws_iam_openid_connect_provider.eks-oidc[0].url, null)
  description = "URL of the secondary OIDC provider that is created by enabling var.enable-oidc-provider. Used for IRSA (IAM Roles for Service Accounts) and EBS CSI."
}

output "secondary_oidc_provider_arn" {
  value       = try(aws_iam_openid_connect_provider.eks-oidc[0].arn, null)
  description = "ARN of the secondary OIDC provider that is created by enabling var.enable-oidc-provider. Used for IRSA (IAM Roles for Service Accounts) and EBS CSI."
}