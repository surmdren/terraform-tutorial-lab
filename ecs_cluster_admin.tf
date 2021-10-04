resource "aws_ecs_cluster" "admin-ecs" {
  name = "${var.service_name}-admin-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge({ Name = "${var.region}-${var.service_name}-admin-ecs" })
}
