module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.1"

  name = "minimal-testing-tf-mod-aws-eks"
  cidr = "10.0.0.0/16"

  azs                     = ["${var.region}a", "${var.region}b"]
  private_subnets         = ["10.0.0.0/23", "10.0.2.0/23"]
  private_subnet_names    = ["private-1", "private-2"]
  public_subnets          = ["10.0.255.0/24", "10.0.254.0/24"]
  public_subnet_names     = ["public-1", "public-2"]
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
    "Network"                                   = "Public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "Network"                                   = "Private"
    # "kubernetes.io/role/internal-elb"           = 1 # Only enable if internal ELB
  }
}
