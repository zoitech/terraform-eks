#  EKS IAM Role

resource "aws_iam_role" "eks-masters" {
  count = var.enable_iam ? 1 : 0

  name = "role_eks_${var.cluster-name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count = var.enable_iam ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-masters[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  count = var.enable_iam ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-masters[0].name
}


# NodeGroups IAM role

resource "aws_iam_role" "nodes" {
  count = var.enable_iam ? 1 : 0

  name = "role_eks_nodes_${var.cluster-name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count = var.enable_iam ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count = var.enable_iam ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count = var.enable_iam ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEBS_CSI_Policy" {
  count = var.enable_ebs_csi_addon ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.aws_ebs_csi_driver_role[0].name
}

######################################
#                 EBS CSI
######################################
resource "aws_iam_role" "aws_ebs_csi_driver_role" {
  count = var.enable_ebs_csi_addon ? 1 : 0

  name        = "EBSCSIDriverRole_${var.cluster-name}"
  description = "Role EBS CSI driver for EKS."

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${trimprefix(split(":", aws_iam_openid_connect_provider.eks-oidc[0].arn)[5], "oidc-provider/")}:aud" : "sts.amazonaws.com",
            "${trimprefix(split(":", aws_iam_openid_connect_provider.eks-oidc[0].arn)[5], "oidc-provider/")}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        },
        Effect = "Allow",
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.eks-oidc[0].arn}"
        }
      }
    ]
  })
}

