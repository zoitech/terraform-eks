locals {
  map-roles = [
    for rolearn, groups in var.map-roles :
   {
      rolearn  = rolearn
      username = "${split("/", rolearn)[1]}{{SessionName}}"
      groups   = groups
    }
  ]

  map-users = [
    for userarn, groups in var.map-users : {
      userarn  = userarn
      username = "${split("/", userarn)[1]}"
      groups   = groups
    }
  ]

  configmap_roles = [
    {
      rolearn  = var.enable_iam ? aws_iam_role.nodes[0].arn : var.eks-nodes-iam-role
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  userdata-file = var.userdata-file != "" ? var.userdata-file : "${path.module}/userdata.txt"
}
