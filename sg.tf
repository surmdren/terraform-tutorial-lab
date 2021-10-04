resource "aws_security_group" "efs" {
  name        = "${var.region}-${var.service_name}-efs-sg"
  description = "${var.region}-${var.service_name}-efs-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = merge({ Name = "${var.region}-${var.service_name}-efs-sg" })
}
# egress all
resource "aws_security_group_rule" "efs-eg-all" {
  security_group_id = aws_security_group.efs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "efs-ingress-2049" {
  security_group_id = aws_security_group.efs.id
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["${aws_vpc.vpc.cidr_block}"] 
  description       = "EFS security group"
}

#Jenkins FARGATE Container, allow traffic from ALB (in the same vpc)
resource "aws_security_group" "jenkins" {
  name        = "${var.region}-${var.service_name}-jenkins-sg"
  description = "${var.service_name} jenkins fargate security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = merge({ Name = "${var.region}-${var.service_name}-jenkins-sg" })

}