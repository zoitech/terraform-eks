locals {
  map-roles = [{
    for rolearn, groups in var.map-roles :
    rolearn => {
      rolearn  = rolearn
      username = "${split("/", rolearn)[1]}{{SessionName}}"
      groups   = groups
    }
  }]

  map-users = {
    for userarn, groups in var.map-users :
    userarn => {
      userarn  = userarn
      username = "${split("/", userarn)[1]}{{SessionName}}"
      groups   = groups
    }
  }

  configmap_roles = [
    {
      rolearn  = aws_iam_role.nodes.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  #need a map  
  /*   aws-auth = <<EOF
mapRoles: | 
  - groups:
    - system:bootstrappers
    - system:nodes
    rolearn: ${aws_iam_role.nodes.arn}
    username: system:node:{{EC2PrivateDNSName}}
%{for arn, groups in var.map-roles~}
  - groups:
  %{for group in groups~}
   - ${group}
  %{ endfor ~}
    rolearn: ${arn}
    username: ${split("/", arn)[1]}{{SessionName}}"  ## needs to be tested
%{ endfor ~}

mapUsers: |
  %{for arn, groups in var.map-users~}
  - groups:
  %{for group in groups~}
   - ${group}
  %{ endfor ~}
    userarn: ${arn}
    username: ${split("/", arn)[1]}{{SessionName}}"  ## needs to be tested
%{ endfor ~}
EOF */
}