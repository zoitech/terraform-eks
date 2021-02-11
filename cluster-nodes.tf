# EKS Node Groups

resource "aws_eks_node_group" "cluster_nodes" {
  cluster_name       = aws_eks_cluster.cluster-masters.name
  node_group_name    = "${var.cluster-name}-nodes-${replace(var.instance-types, ".", "_")}"
  node_role_arn      = aws_iam_role.nodes.arn
  subnet_ids         = var.nodes-subnets-ids
  security_group_ids = var.nodes-nodes-additional-security-groups

  launch_template {
    id = aws_launch_template.cluster-nodes-launch-template.id
    version = aws_launch_template.cluster-nodes-launch-template.latest_version
  }

  scaling_config {
    desired_size = var.nodes-count
    max_size     = var.max-nodes-count
    min_size     = var.min-nodes-count
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.cluster-masters,
    aws_launch_template.cluster-nodes-launch-template,
  ]
}

  