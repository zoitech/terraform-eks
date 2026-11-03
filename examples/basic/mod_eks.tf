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
  vpc-id                           = var.vpc_id
  cluster-subnets-ids              = var.eks_subnet_ids
  primary-node-subnets-ids         = var.eks_subnet_ids
  eks-additional-security-groups   = []
  enable-private-access            = var.enable-private-access
  enable-public-access             = var.enable-public-access
  nodes-additional-security-groups = []
  service_ipv4_cidr                = var.service_ipv4_cidr
  cluster-authentication-mode      = "API"
  enable-oidc-provider             = var.enable-oidc-provider

  # add-ons
  create_eks_addons       = var.create_eks_addons
  enable_vpc_cni_addon    = var.enable_vpc_cni_addon
  enable_coredns_addon    = var.enable_coredns_addon
  enable_ebs_csi_addon    = var.enable_ebs_csi_addon
  enable_kube_proxy_addon = var.enable_kube_proxy_addon

  tags = {
    owner = var.owner_tag
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
