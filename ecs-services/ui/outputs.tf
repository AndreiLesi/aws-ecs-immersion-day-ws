output "service_output" {
  value = module.ecs_service.service_output
  description = "Name of the ECS service"
}
