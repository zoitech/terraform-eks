resource "aws_eks_node_group" "cluster_nodes" {
  count              = var.enable-primary-nodegroup ? 1 : 0
  
  cluster_name       = aws_eks_cluster.cluster-masters.name
  node_group_name    = "${var.cluster-name}-nodes-${replace(var.primary-instance-type, ".", "_")}"
  node_role_arn      = var.enable_iam ? aws_iam_role.nodes[0].arn : var.eks-nodes-iam-role
  subnet_ids         = var.primary-node-subnets-ids
  version            = var.nodes-version
  instance_types     = [var.primary-instance-type]
  tags               = var.tags

  launch_template {
    id      = aws_launch_template.cluster-nodes-launch-template.id
    version = aws_launch_template.cluster-nodes-launch-template.latest_version
  }

  scaling_config {
    desired_size = var.primary-nodes-count
    max_size     = var.primary-max-nodes-count
    min_size     = var.primary-min-nodes-count
  }

  lifecycle {
    ignore_changes = [scaling_config.0.desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.cluster-masters,
    aws_launch_template.cluster-nodes-launch-template,
    kubernetes_config_map.aws_auth
  ]
}


