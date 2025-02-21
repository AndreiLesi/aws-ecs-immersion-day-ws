module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = var.container_name
  cluster_arn = var.cluster_arn

  cpu    = 256
  memory = 512
  enable_execute_command = true
  health_check_grace_period_seconds = 60
  autoscaling_policies = var.autoscaling_policy

  # Container definition(s)
  container_definitions = {

    application = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = var.container_image
      readonly_root_filesystem = false
      environment = local.environment_variables
      secrets = local.secrets
      port_mappings = [
        {
          name          = "application"
          containerPort = var.container_port
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
            dns_name = var.container_name
        }
        port_name      = "application"
        discovery_name = var.container_name
        }
    }

    load_balancer = var.load_balancer_target_group_arn != "" ? [{
        target_group_arn = var.load_balancer_target_group_arn
        container_name   = "application"
        container_port   = var.container_port
        
    }] : []

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