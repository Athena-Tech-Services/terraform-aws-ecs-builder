data "aws_subnets" "default_public_subnets" {
  tags = {
    Type = "Public"
  }
}

data "aws_security_groups" "default_security_group" {
  tags = {
    Type = "default"
  }
}


locals {
  network_configuration = {
    subnets          = length(var.network_configuration.subnets) == 0 ? toset(data.aws_subnets.default_public_subnets.ids) : var.network_configuration.subnets
    security_groups  = length(var.network_configuration.security_groups) == 0 ? toset(data.aws_security_groups.default_security_group.ids) : var.network_configuration.security_groups
    assign_public_ip = length(var.network_configuration.subnets) == 0 ? true : var.network_configuration.assign_public_ip
  }
}
resource "aws_ecs_service" "ecs" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  tags            = var.tags
  capacity_provider_strategy {
    base              = var.capacity_strategy.capacity_base
    capacity_provider = var.capacity_strategy.capacity_provider_name
    weight            = var.capacity_strategy.capacity_weight
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.service_name
    container_port   = var.container_port
  }
  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
  network_configuration {
    subnets          = local.network_configuration.subnets
    security_groups  = local.network_configuration.security_groups
    assign_public_ip = local.network_configuration.assign_public_ip
  }
}


