output "service_output" {
  value = module.ecs_service.service_output
  description = "Output of the ECS service"
}
