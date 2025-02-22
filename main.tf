module "core-infra" {
  source = "./core-infra"
  project_name = local.project_name
}

module "service-assets" {
  source = "./ecs-services/assets"
  healthcheck_path = "/health.html"
  project_name = local.project_name
  cluster_arn = module.core-infra.cluster_arn
  subnet_ids = module.core-infra.vpc.private_subnets
  service_namespace_arn = module.core-infra.service_discovery_namespace_arn
}

module "service-ui" {
  source = "./ecs-services/ui"
  project_name = local.project_name
  cluster_arn = module.core-infra.cluster_arn
  subnet_ids = module.core-infra.vpc.private_subnets
  service_namespace_arn = module.core-infra.service_discovery_namespace_arn
  public_subnet_ids = module.core-infra.vpc.public_subnets
  healthcheck_path = "/actuator/health"
  vpc_id = module.core-infra.vpc.vpc_id
  environment_variables = {
    ENDPOINTS_CATALOG  = "http://${module.service-catalog.service_output.name}"
    ENDPOINTS_ASSETS   = "http://${module.service-assets.service_output.name}"
    ENDPOINTS_CARTS    = "http://${module.service-carts.service_output.name}"
  }
}

module "service-catalog" {
  source = "./ecs-services/catalog"
  project_name = local.project_name
  cluster_arn = module.core-infra.cluster_arn
  subnet_ids = module.core-infra.vpc.private_subnets
  service_namespace_arn = module.core-infra.service_discovery_namespace_arn
  vpc_id = module.core-infra.vpc.vpc_id
  healthcheck_path = "/health"
}

module "service-carts" {
  source = "./ecs-services/carts"
  project_name = local.project_name
  cluster_arn = module.core-infra.cluster_arn
  subnet_ids = module.core-infra.vpc.private_subnets
  service_namespace_arn = module.core-infra.service_discovery_namespace_arn
  healthcheck_path = "/actuator/health"
}