module "eks" {

  source = "../.."

  # Mandatory fields
  cluster-name        = var.cluster-name
  vpc-id              = module.vpc.vpc_id
  cluster-subnets-ids = module.vpc.private_subnets

  # Optional fields
  master-nodes-k8s-version         = "1.37" # latest is used if not specified
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

  depends_on = [module.vpc]
}
