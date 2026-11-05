data "aws_caller_identity" "current" {}

# cannot specify a kubernetes version to use
# when specifying an image id to use within the launch template.
# https://github.com/awslabs/amazon-eks-ami/blob/main/CHANGELOG.md
data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${local.effective_nodes_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

data "aws_eks_addon_version" "vpc_cni_default" {
  count = var.create_eks_addons && var.enable_vpc_cni_addon && var.eks_addon_version_vpc_cni == "" ? 1 : 0

  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.cluster-masters.version
}

data "aws_eks_addon_version" "kube_proxy_default" {
  count = var.create_eks_addons && var.enable_kube_proxy_addon && var.eks_addon_version_kube_proxy == "" ? 1 : 0

  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.cluster-masters.version
}

data "aws_eks_addon_version" "core_dns_default" {
  count = var.create_eks_addons && var.enable_coredns_addon && var.eks_addon_version_core_dns == "" ? 1 : 0

  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.cluster-masters.version
}

data "aws_eks_addon_version" "ebs_csi_default" {
  count = var.create_eks_addons && var.enable_ebs_csi_addon && var.ebs_csi_driver_version == "" ? 1 : 0

  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.cluster-masters.version
}
