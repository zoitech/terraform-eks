# related to apiVersion: node.eks.aws/v1alpha1
# https://github.com/awslabs/amazon-eks-ami/tree/main/nodeadm/api
locals {

  userdata_node_config = <<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    apiServerEndpoint: ${aws_eks_cluster.cluster-masters.endpoint}
    certificateAuthority: ${aws_eks_cluster.cluster-masters.certificate_authority[0].data}
    cidr: ${var.service_ipv4_cidr}
    name: ${aws_eks_cluster.cluster-masters.id}
  kubelet:
    flags:
    - "--node-labels=key=value"

--BOUNDARY
Content-Type: text/x-shellscript;

#!/bin/bash
  set -o xtrace
  yum install htop -y

--BOUNDARY--
  EOF
}
