resource "aws_launch_template" "cluster-nodes-launch-template" {
  name = "cluster-nodes-launch-template"
  
  instance_type = var.instance-types
  image_id = var.nodes-ami-release
  vpc_security_group_ids = aws_security_group.group-eks-nodes.id

  tag_specifications {
    resource_type = "instance"
    
    tags = var.node-tags
  } 

}

