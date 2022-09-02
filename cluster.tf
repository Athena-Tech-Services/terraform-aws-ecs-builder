resource "aws_cloudwatch_log_group" "cluster_log_group" {
  name = "${var.project_name}_log_group"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.project_name
  tags = var.tags
}
