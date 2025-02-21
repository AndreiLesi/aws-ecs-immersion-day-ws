module "ecs_service" {
  source = "../lib/service"
  container_name = "ui"
  container_port = 8080
  container_image = "public.ecr.aws/aws-containers/retail-store-sample-ui:0.8.5"
  cluster_arn = var.cluster_arn
  project_name = var.project_name
  subnet_ids = var.subnet_ids
  service_namespace_arn = var.service_namespace_arn
  load_balancer_target_group_arn = module.alb.target_group_arns[0]
  healthcheck_path = "/actuator/health"
  environment_variables = var.environment_variables
  secrets = var.secrets
  autoscaling_policy = {
    "RequestsCount": {
      "policy_type": "TargetTrackingScaling",
      "target_tracking_scaling_policy_configuration": {
        "target_value": 1500,
        "predefined_metric_specification": {
          "predefined_metric_type": "ALBRequestCountPerTarget",
          "resource_label": "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}",
        }
      }
    }
  }
}

