module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0.2"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = local.azs
  private_subnets         = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  private_subnet_names    = [for az in local.azs : "private-${substr(az, -2, -1)}"]
  public_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k + 12)]
  public_subnet_names     = [for az in local.azs : "public-${substr(az, -2, -1)}"]
  map_public_ip_on_launch = true

  enable_ipv6            = false
  create_egress_only_igw = true

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = false
  create_flow_log_cloudwatch_iam_role  = false
  create_flow_log_cloudwatch_log_group = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    # "kubernetes.io/role/internal-elb"           = 1 # Only enable if internal ELB
  }
}
