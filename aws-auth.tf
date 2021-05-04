resource "kubernetes_config_map" "aws_auth" {
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
    mapRoles    = yamlencode(
      distinct(concat(
        local.configmap_roles,
        var.map-roles
      )))

    mapUsers    = yamlencode(var.map-users)
  }

   depends_on = [
    aws_eks_cluster.cluster-masters,
    aws_security_group_rule.Group-eks-self
  ]
}