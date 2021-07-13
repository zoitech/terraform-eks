resource "kubernetes_config_map" "aws_auth" {
  count = var.enable-aws-auth ? 1 : 0
  #for_each = var.map-roles

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "Terraform"
      },
    )
  }

  data = {
    mapRoles = yamlencode(concat(
      local.configmap_roles,
      local.map-roles
    ))

    mapUsers = yamlencode(
      local.map-users
    )
  }

  depends_on = [
    aws_eks_cluster.cluster-masters,
    aws_security_group_rule.Group-eks-self
  ]
}