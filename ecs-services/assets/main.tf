module "ecs_service" {
  source = "../lib/service"
  container_name = "assets"
  container_port = 8080
  container_image = "public.ecr.aws/aws-containers/retail-store-sample-assets:0.8.5"
  cluster_arn = var.cluster_arn
  project_name = var.project_name
  subnet_ids = var.subnet_ids
  service_namespace_arn = var.service_namespace_arn
  healthcheck_path = "/health.html"
}