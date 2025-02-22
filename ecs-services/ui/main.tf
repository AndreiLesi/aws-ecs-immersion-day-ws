module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = local.container_name
  cluster_arn = var.cluster_arn

  cpu    = 256
  memory = 512
  enable_execute_command = true
  health_check_grace_period_seconds = 60
  autoscaling_policies = {
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

  # Container definition(s)
  container_definitions = {

    application = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = local.container_image
      readonly_root_filesystem = false
      environment = local.environment_variables
      secrets = local.secrets
      health = {
        command = ["CMD-SHELL", "curl -f http://localhost:8080/${local.healthcheck_path} || exit 1"]
        interval = 30
        retries  = 3
        timeout  = 5
        start_period = 60
      }
      port_mappings = [
        {
          name          = "application"
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]
    }
  }

    service_connect_configuration = {
        namespace = var.service_namespace_arn
        enabled = true
        service = {
        client_alias = {
            port     = 80
            dns_name = local.container_name
        }
        port_name      = "application"
        discovery_name = local.container_name
        }
    }

    load_balancer = {
      service = {
        target_group_arn = module.alb.target_group_arns[0]
        container_name   = "application"
        container_port   = local.container_port
      }
    }

  subnet_ids = var.subnet_ids
  security_group_rules = {
    ingress = {
      type                     = "ingress"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Service port"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}