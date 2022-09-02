variable "project_name" {
  type        = string
  description = "Name of the project"
}


variable "tags" {
  type = object({
    Project     = string,
    Environment = string
  })
}

variable "requires_compatibilities" {
  type        = list(string)
  description = "list of required compatibilities"
  default     = ["FARGATE"]
  validation {
    condition     = length(var.requires_compatibilities) > 0 && length(var.requires_compatibilities) <= 2
    error_message = "required_compatibilities must be between 1 and 2"
  }
}

variable "container_definitions" {
  type        = list(object)
  description = "Container definition for the service"
}

variable "network_mode" {
  type        = string
  description = "network mode"
  default     = "awsvpc"
}

variable "service_iam_permissions" {
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  description = "service iam permissions"
}

variable "memory" {
  type        = number
  default     = 2048
  description = "The memory in MiB for the task"
}

variable "cpu" {
  type        = number
  default     = 512
  description = "Nmber of cpu units for the task"
}


variable "desired_count" {
  type        = number
  default     = 1
  description = "The number of tasks to run for the service"
}

variable "container_port" {
  type        = number
  default     = 3000
  description = "The container port number"
}

variable "capacity_strategy" {
  type = object({
    capacity_base          = number
    capacity_provider_name = string
    capacity_weight        = number
  })
  description = "The capacity strategy"
  default = {
    capacity_base          = 0
    capacity_provider_name = "FARGATE_SPOT"
    capacity_weight        = 1
  }
}

variable "network_configuration" {
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })
  description = "network configuration for the ecs service"
}
