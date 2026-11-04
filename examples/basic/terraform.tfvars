cluster-name             = "test-cluster"
vpc_id                   = ""
eks_subnet_ids           = ["subnet-", "subnet-", "subnet-"]
master-nodes-k8s-version = "1.37"
worker-nodes-k8s-version = "1.37"
enable-primary-nodegroup = true
primary-nodes-count      = "1"
primary-min-nodes-count  = "1"
primary-max-nodes-count  = "3"
nodegroup-instance-types = ["t3.medium"]
enable-private-access    = false
enable-public-access     = true # Public cluster
service_ipv4_cidr        = "172.20.0.0/16"
enable-oidc-provider     = true

# add-ons
create_eks_addons       = true
enable_vpc_cni_addon    = true
enable_coredns_addon    = true
enable_ebs_csi_addon    = true
enable_kube_proxy_addon = true

# Tags
owner_tag = "test.user@example.com"
