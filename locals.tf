locals {
  enable-oidc-provider = var.enable_ebs_csi_addon || var.enable-oidc-provider

  map-roles = [
    for value in var.map-roles :
    {
      rolearn  = value.rolearn
      username = value.username
      groups   = value.groups
    }
  ]

  map-users = [
    for value in var.map-users :
    {
      userarn  = value.userarn
      username = value.username
      groups   = value.groups
    }
  ]

  configmap_roles = [
    {
      rolearn  = var.enable_iam ? aws_iam_role.nodes[0].arn : var.eks-nodes-iam-role
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  effective_nodes_version = var.worker-nodes-k8s-version != "" ? var.worker-nodes-k8s-version : var.master-nodes-k8s-version

  # Addon versions resolution flow:
  # 1. If addon version variable is specified, use it
  # 2. Otherwise, query AWS for the default version (via data source)
  # 3. If data source exists, use its version
  # 4. Fallback to null if no version found

  kube_proxy_addon_version = var.eks_addon_version_kube_proxy != "" ? (
    var.eks_addon_version_kube_proxy
    ) : (
    length(data.aws_eks_addon_version.kube_proxy_default) > 0 ?
    data.aws_eks_addon_version.kube_proxy_default[0].version :
    null
  )

  coredns_addon_version = var.eks_addon_version_core_dns != "" ? (
    var.eks_addon_version_core_dns
    ) : (
    length(data.aws_eks_addon_version.core_dns_default) > 0 ?
    data.aws_eks_addon_version.core_dns_default[0].version :
    null
  )

  vpc_cni_addon_version = var.eks_addon_version_vpc_cni != "" ? (
    var.eks_addon_version_vpc_cni
    ) : (
    length(data.aws_eks_addon_version.vpc_cni_default) > 0 ?
    data.aws_eks_addon_version.vpc_cni_default[0].version :
    null
  )

  ebs_csi_addon_version = var.ebs_csi_driver_version != "" ? (
    var.ebs_csi_driver_version
    ) : (
    length(data.aws_eks_addon_version.ebs_csi_default) > 0 ?
    data.aws_eks_addon_version.ebs_csi_default[0].version :
    null
  )
}
