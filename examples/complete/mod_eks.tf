module "eks" {

  source = "../.."

  cluster-name                     = var.cluster-name
  cluster-authentication-mode      = var.cluster-authentication-mode
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
  service_ipv4_cidr                = var.service_ipv4_cidr

  # Cluster encryption configuration
  enable_cluster_encryption_config = var.enable_cluster_encryption_config
  cluster_encryption_config        = var.cluster_encryption_config
  secrets_manager_iam_role_arns    = var.secrets_manager_iam_role_arns
  kms_policy_admin_arns            = local.kms_policy_admin_arns

  # add-ons
  create_eks_addons       = var.create_eks_addons
  enable_vpc_cni_addon    = var.enable_vpc_cni_addon
  enable_coredns_addon    = var.enable_coredns_addon
  enable_ebs_csi_addon    = var.enable_ebs_csi_addon
  enable_kube_proxy_addon = var.enable_kube_proxy_addon

  # Spot instances
  enable-spot-instances = var.enable-spot-instances
  spot-instance-types   = var.spot-instance-types
  spot-max-nodes-count  = var.spot-max-nodes-count
  spot-min-nodes-count  = var.spot-min-nodes-count
  spot-nodes-count      = var.spot-nodes-count
  spot-node-subnets-ids = module.vpc.private_subnets

  tags = {
    eks = "true"
  }

  enable-oidc-provider = var.enable-oidc-provider
  # eks_svc_account_roles            = {
  #   role1 = {
  #     role_name      = "role1"
  #     namespace      = "default"
  #     svc_account    = "service-account-1"
  #     iam_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  #   }
  # }

  # AWS-AUTH configmap (Legacy)
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
