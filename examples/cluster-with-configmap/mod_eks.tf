module "eks" {

  source = "../.."

  # Mandatory fields
  region              = var.region
  cluster-name        = var.cluster-name
  vpc-id              = module.vpc.vpc_id
  cluster-subnets-ids = module.vpc.private_subnets

  # Optional fields
  master-nodes-k8s-version         = "1.34" # latest is used if not specified
  worker-nodes-k8s-version         = ""     # empty means use master-nodes-k8s-version
  enable-primary-nodegroup         = true
  primary-nodes-count              = "1"
  primary-min-nodes-count          = "1"
  primary-max-nodes-count          = "1"
  nodegroup-instance-types         = ["t3.medium"]
  primary-node-subnets-ids         = module.vpc.private_subnets
  enable_cluster_encryption_config = true

  enable-public-access = "true" # Required for testing calls from Internet!!

  tags = {
    eks = "true"
  }

  enable-aws-auth = true
  map-users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cluster-with-configmap-user1"
      groups   = ["system:masters"]
      username = "cluster-with-configmap-user1"
    }
  ]

  map-roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cluster-with-configmap-role1"
      groups   = ["system:masters"]
      username = "cluster-with-configmap-role1_{{SessionName}}"
    }
  ]

  depends_on = [module.vpc]
}
