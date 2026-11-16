resource "aws_eks_addon" "kube_proxy" {
  count = var.create_eks_addons && var.enable_kube_proxy_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster-masters.name
  addon_name                  = "kube-proxy"
  addon_version               = local.kube_proxy_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_kube_proxy
}

resource "aws_eks_addon" "core_dns" {
  count = var.create_eks_addons && var.enable_coredns_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster-masters.name
  addon_name                  = "coredns"
  addon_version               = local.coredns_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_core_dns
  configuration_values        = var.coredns_configuration_values

  depends_on = [
    aws_eks_node_group.cluster_nodes,
    aws_eks_node_group.spot_cluster_nodes
  ]
}

resource "aws_eks_addon" "vpc-cni" {
  count = var.create_eks_addons && var.enable_vpc_cni_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster-masters.name
  addon_name                  = "vpc-cni"
  addon_version               = local.vpc_cni_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_vpc_cni
}

resource "aws_eks_addon" "ebs_csi" {
  count = var.create_eks_addons && var.enable_ebs_csi_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.cluster-masters.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = local.ebs_csi_addon_version
  resolve_conflicts_on_update = var.eks_addon_resolve_conflicts_ebs_csi
  service_account_role_arn    = aws_iam_role.aws_ebs_csi_driver_role[0].arn

  depends_on = [
    aws_eks_node_group.cluster_nodes,
    aws_iam_role_policy_attachment.AmazonEBS_CSI_Policy
  ]
}
