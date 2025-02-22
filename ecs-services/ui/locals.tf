locals {
    container_name = "ui"
  container_port = 8080
  container_image = "public.ecr.aws/aws-containers/retail-store-sample-ui:0.8.5"
  healthcheck_path = "/actuator/health"
  environment_variables = [for k, v in var.environment_variables : {
    "name" : k,
    "value" : v
  }]

  secrets = [for k, v in var.secrets : {
    "name" : k,
    "valueFrom" : v
  }]
}