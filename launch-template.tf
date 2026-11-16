# Trigger resource that only changes when the node version changes OR force_ami_update changes
resource "terraform_data" "node_version_trigger" {
  input = "${local.effective_nodes_version}-${var.force_ami_update}"
}

resource "aws_launch_template" "cluster-nodes-launch-template" {
  name_prefix = "${var.cluster-name}-eks-nodes-lt-"
  image_id    = data.aws_ssm_parameter.eks_ami.value
  vpc_security_group_ids = flatten([
    [aws_security_group.Group-eks-nodes.id,
      aws_security_group.Group-eks.id,
      aws_eks_cluster.cluster-masters[*].vpc_config[0].cluster_security_group_id
    ],
    var.nodes-additional-security-groups
  ])
  user_data = var.userdata-file != "" ? filebase64(var.userdata-file) : base64encode(local.userdata_node_config)

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.node_version_trigger]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
