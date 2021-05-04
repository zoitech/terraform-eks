resource "aws_eks_node_group" "spot_cluster_nodes" {
  count                 = var.enable-spot-instances ? 1 : 0
  cluster_name          = var.cluster-name
  node_group_name       = "${var.cluster-name}-spot-ng"
  node_role_arn         = aws_iam_role.nodes.arn
  subnet_ids            = var.spot-node-subnets-ids
  version               = var.nodes-version
  capacity_type         = "SPOT"
  instance_types        = var.spot-instance-types
  tags                  = var.tags
  
  launch_template {
    id      = aws_launch_template.cluster-nodes-launch-template.id
    version = aws_launch_template.cluster-nodes-launch-template.latest_version
  }

  scaling_config {
    desired_size = var.primary-nodes-count
    max_size     = var.primary-max-nodes-count
    min_size     = var.primary-min-nodes-count
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
