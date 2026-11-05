region   = "eu-central-1"
vpc_cidr = "10.0.0.0/16"
vpc_name = "test-vpc"

cluster-name                = "test-cluster"
cluster-authentication-mode = "API"
master-nodes-k8s-version    = "1.37"
worker-nodes-k8s-version    = "1.37"
enable-primary-nodegroup    = true
primary-nodes-count         = "2"
primary-min-nodes-count     = "2"
primary-max-nodes-count     = "5"
nodegroup-instance-types    = ["t3.medium"]
enable-private-access       = false
enable-public-access        = true # Public cluster
enable-oidc-provider        = true


# add-ons
create_eks_addons       = true
enable_vpc_cni_addon    = true
enable_coredns_addon    = true
enable_ebs_csi_addon    = true
enable_kube_proxy_addon = true

# Spot instances
enable-spot-instances = false
# spot-node-subnets-ids            = ""
# spot-instance-types              = []
# spot-nodes-count                 = 0
# spot-max-nodes-count             = 2
# spot-min-nodes-count             = 0

# userdata-file                    = "./userdata.txt"
