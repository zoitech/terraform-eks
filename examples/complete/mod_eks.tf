module "eks" {

  source = "../.."

  region                           = var.region
  cluster-name                     = var.cluster-name
  master-nodes-k8s-version         = var.master-nodes-k8s-version
  worker-nodes-k8s-version         = var.worker-nodes-k8s-version
  enable-primary-nodegroup         = var.enable-primary-nodegroup
  primary-nodes-count              = var.primary-nodes-count
  primary-min-nodes-count          = var.primary-min-nodes-count
  primary-max-nodes-count          = var.primary-max-nodes-count
  nodegroup-instance-types         = var.nodegroup-instance-types
  vpc-id                           = module.vpc.vpc_id
  cluster-subnets-ids              = module.vpc.private_subnets
  primary-node-subnets-ids         = module.vpc.private_subnets
  eks-additional-security-groups   = []
  enable-private-access            = var.enable-private-access
  enable-public-access             = var.enable-public-access
  nodes-additional-security-groups = [aws_security_group.eks_nodes_sg.id]
  enable-spot-instances            = var.enable-spot-instances
  service_ipv4_cidr                = var.service_ipv4_cidr
  enable-oidc-provider             = var.enable-oidc-provider

  # add-ons
  create_eks_addons       = var.create_eks_addons
  enable_vpc_cni_addon    = var.enable_vpc_cni_addon
  enable_coredns_addon    = var.enable_coredns_addon
  enable_ebs_csi_addon    = var.enable_ebs_csi_addon
  enable_kube_proxy_addon = var.enable_kube_proxy_addon

  tags = {
    eks = "true"
  }

  # map-users = [
  #   {
  #     userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test.user"
  #     groups   = ["system:masters"]
  #     username = "test1"
  #   },
  #   {
  #     userarn  = aws_iam_user.test2.arn
  #     groups   = ["system:masters"]
  #     username = "test2"
  #   }
  # ]

  # map-roles = [
  #   {
  #     rolearn  = aws_iam_role.test_role.arn
  #     groups   = ["system:masters"]
  #     username = "test_admin_{{SessionName}}"
  #   },
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/test-role-2"
  #     groups   = ["system:masters"]
  #     username = "test2_admin_{{SessionName}}"
  #   }
  # ]
}

##################################
#             Addons             #
##################################
# module "eks_addons" {
#   source = "git::"

#   region                   = var.region
#   env                      = var.env
#   cluster_name             = var.cluster-name
#   enable_fluentbit         = var.enable_fluentbit
#   oidc_arn                 = module.oidc.oidc_arn

#   # Autoscaler
#   autoscaler_chart_version = var.autoscaler_chart_version
#   autoscaler_values = {
#     "rbac.serviceAccount.name"   = "autoscaler"
#     "rbac.serviceAccount.create" = "true"
#   }
#   # Load Balancer Controller
#   aws_lb_chart_version = var.aws_lb_chart_version
#   aws_lb_controller_values = {
#     "clusterName" = var.cluster-name
#     # "ingressClass" = "nginx"
#   }
#   # Secrets Manager
#   secrets_store_csi_driver_version = var.secrets_store_csi_driver_version
#   secrets_provider_aws_version     = var.secrets_provider_aws_version
#   aws_secrets_manager_namespaces   = var.aws_secrets_manager_namespaces
#   create_k8s_namespaces            = var.create_k8s_namespaces

#   tags = merge(var.tags, {
#     env = var.env
#   })

#   eks_nodegroups_role_name = module.eks.eks_nodes_role_name
#   depends_on               = [module.eks]
# }
