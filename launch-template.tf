resource "aws_launch_template" "cluster-nodes-launch-template" {
  name                   = "${var.cluster-name}-eks-nodes-lt"
  vpc_security_group_ids = flatten([[aws_security_group.Group-eks-nodes.id, aws_security_group.Group-eks.id, aws_eks_cluster.cluster-masters[*].vpc_config[0].cluster_security_group_id], var.nodes-additional-security-groups])
  user_data              = filebase64(var.userdata-file)
  tags                   = var.tags

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

