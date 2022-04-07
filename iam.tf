# EKS IAM Role
resource "aws_iam_role" "eks-masters" {
  count = var.enable_iam ? 1 : 0

  name = "role_eks_${var.cluster-name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
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

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
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

