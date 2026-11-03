##################################################
#              OIDC
##################################################
# Enable OIDC provider for the EBS CSI driver and IRSA.

data "tls_certificate" "cluster" {
  count = local.enable-oidc-provider ? 1 : 0

  url = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks-oidc" {
  count = local.enable-oidc-provider ? 1 : 0

  url             = aws_eks_cluster.cluster-masters.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster[0].certificates[0].sha1_fingerprint]

}

#IAM role for Service Accounts in EKS Cluster
resource "aws_iam_role" "access_eks_service_account_role" {
  for_each = local.enable-oidc-provider ? var.eks_svc_account_roles : {}

  name        = each.value.role_name
  description = "Role for AWS Service to access EKS cluster ${var.cluster-name}, with service accounts ${each.value.svc_account}."


  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": "sts:AssumeRoleWithWebIdentity",
		"Condition": {
			"StringEquals": {
        "${trimprefix(split(":", aws_iam_openid_connect_provider.eks-oidc[0].arn)[5], "oidc-provider/")}:sub": "system:serviceaccount:${each.value.namespace}:${each.value.svc_account}"
		 }
    },
		"Effect": "Allow",
		"Principal": {
			"Federated": "${aws_iam_openid_connect_provider.eks-oidc[0].arn}"
		}
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "access_eks_service_account_role_attachment" {
  for_each = aws_iam_role.access_eks_service_account_role

  role       = each.value.name
  policy_arn = var.eks_svc_account_roles[each.key].iam_policy_arn
}

