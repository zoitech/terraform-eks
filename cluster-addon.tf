resource "aws_eks_addon" "kube_proxy" {
    count = var.create_eks_addons ? 1 : 0   

    cluster_name = var.cluster-name
    addon_name = "kube-proxy"
    resolve_conflicts = "OVERWRITE"
    
    depends_on = [
      aws_eks_cluster.cluster_nodes
    ]

}
resource "aws_eks_addon" "core_dns" {
    count = var.create_eks_addons ? 1 : 0 

    cluster_name = var.cluster-name
    addon_name = "coredns"
    resolve_conflicts = "OVERWRITE"

    depends_on = [
      aws_eks_cluster.cluster_nodes
    ]
}

resource "aws_eks_addon" "vpc-cni" {
    count = var.create_eks_addons ? 1 : 0 

    cluster_name = var.cluster-name
    addon_name = "vpc-cni"
    resolve_conflicts = "OVERWRITE"

    depends_on = [
      aws_eks_cluster.cluster_nodes
    ]
}