#  EC2 Security Group to allow networking traffic with EKS cluster

resource "aws_security_group" "Group-eks" {
  name        = "Group-eks-${var.cluster-name}"
  description = "Allow masters to communicate with nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "Group-eks-self" {
  self              = true
  description       = "Allow communication with the cluster API Server"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.Group-eks.id
  to_port           = "0"
  type              = "ingress"
}
