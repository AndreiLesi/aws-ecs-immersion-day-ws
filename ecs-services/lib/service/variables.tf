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

variable "tasks_iam_role_policies" {
  description = "A list of IAM policy ARNs to attach to the task execution role"
  type        = map(string)
  default     = {}
}