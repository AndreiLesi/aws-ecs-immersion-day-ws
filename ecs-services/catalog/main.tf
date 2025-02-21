module "ecs_service" {
  source = "../lib/service"
  container_name = "catalog"
  container_port = 8080
  container_image = "public.ecr.aws/aws-containers/retail-store-sample-catalog:0.8.5"
  cluster_arn = var.cluster_arn
  project_name = var.project_name
  subnet_ids = var.subnet_ids
  service_namespace_arn = var.service_namespace_arn
  environment_variables = {
    DB_NAME = "catalog"
  }
  secrets = {
    DB_ENDPOINT = "${aws_secretsmanager_secret_version.catalog_db.arn}:host::",
    DB_USER = "${aws_secretsmanager_secret_version.catalog_db.arn}:username::",
    DB_PASSWORD = "${aws_secretsmanager_secret_version.catalog_db.arn}:password::"
  }
}