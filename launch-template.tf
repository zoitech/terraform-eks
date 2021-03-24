resource "aws_launch_template" "cluster-nodes-launch-template" {
  name = "cluster-nodes-launch-template"
  
  instance_type = var.instance-types
  vpc_security_group_ids = flatten([[aws_security_group.Group-eks-nodes.id, aws_security_group.Group-eks.id, aws_eks_cluster.cluster-masters[*].vpc_config[0].cluster_security_group_id], var.nodes-additional-security-groups])
  

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  } 

}

#auto-scaling on-demand no auto-scaler
