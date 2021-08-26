resource "aws_eks_addon" "kube_proxy" {
    count = var.create_eks_addons && var.enable-primary-nodegroup ? 1 : 0

    cluster_name = var.cluster-name
    addon_name = "kube-proxy"
    addon_version = var.eks_addon_version_kube_proxy
    resolve_conflicts = "OVERWRITE"
    
    depends_on = [
      aws_eks_cluster.cluster-masters
    ]

}
resource "aws_eks_addon" "core_dns" {
    count = var.create_eks_addons && var.enable-primary-nodegroup ? 1 : 0

    cluster_name = var.cluster-name
    addon_name = "coredns"
    addon_version = var.eks_addon_version_core_dns
    resolve_conflicts = "OVERWRITE"

    depends_on = [
      aws_eks_node_group.cluster_nodes
    ]
}

resource "aws_eks_addon" "vpc-cni" {
    count = var.create_eks_addons ? 1 : 0

    cluster_name = var.cluster-name
    addon_name = "vpc-cni"
    addon_version = var.eks_addon_version_vpc_cni
    resolve_conflicts = "OVERWRITE"

    depends_on = [
      aws_eks_cluster.cluster-masters
    ]
}