variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
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
  description = "A map of secrets to set on the container"
  type        = map(string)
  default = {}
}

variable "subnet_ids" {
  description = "A list of subnet IDs to place the task in"
  type        = list(string)
}

variable "healthcheck_path" {
  description = "The path to use for the health check"
}

variable "service_namespace_arn" {
  description = "The ARN of the service discovery namespace"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  description = "A list of subnet IDs to place the load balancer in"
  type        = list(string)
}