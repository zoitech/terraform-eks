# EKS Node Groups

resource "aws_eks_node_group" "cluster_nodes" {
  cluster_name    = aws_eks_cluster.cluster-masters.name
  node_group_name = "${var.cluster-name}-nodes-${replace(var.instance-types, ".", "_")}"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.nodes-subnets-ids
  instance_types  = [var.instance-types]
  version         = var.nodes-version
  release_version = var.nodes-ami-release

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
  ]
}
