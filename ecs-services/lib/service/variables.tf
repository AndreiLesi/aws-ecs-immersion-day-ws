variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
}

variable "container_name" {
  description = "The name of the container"
}

variable "container_port" {
  description = "The port the container listens on"
}

variable "container_image" {
  description = "The image to use for the container"
}

variable "project_name" {
  description = "The name of the project"
}

variable "environment_variables" {
  description = "A map of environment variables to set on the container"
  type        = map(string)
  default = {}
}

variable "secrets" {
  description = "A map of environment variables to set on the container"
  type        = map(string)
  default = {}
}

variable "subnet_ids" {
  description = "A list of subnet IDs to place the task in"
  type        = list(string)
}

variable "healthcheck_path" {
  description = "The path to use for the health check"
  default = "/health"
}

variable "service_namespace_arn" {
  description = "The ARN of the service discovery namespace"
}

variable "load_balancer_target_group_arn" {
  description = "The ARN of the target group to associate with the service"
  type        = string
  default = ""
}

variable "autoscaling_policy" {
  description = "The autoscaling policy to use for the service"
  default = {
    "cpu": {
      "policy_type": "TargetTrackingScaling",
      "target_tracking_scaling_policy_configuration": {
        "predefined_metric_specification": {
          "predefined_metric_type": "ECSServiceAverageCPUUtilization"
        }
      }
    },
    "memory": {
      "policy_type": "TargetTrackingScaling",
      "target_tracking_scaling_policy_configuration": {
        "predefined_metric_specification": {
          "predefined_metric_type": "ECSServiceAverageMemoryUtilization"
        }
      }
    }
  }
}