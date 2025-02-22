module "ecs_service" {
  source = "../lib/service"
  container_name = "cart"
  container_port = 8080
  container_image = "public.ecr.aws/aws-containers/retail-store-sample-cart:0.8.5"
  cluster_arn = var.cluster_arn
  project_name = var.project_name
  subnet_ids = var.subnet_ids
  service_namespace_arn = var.service_namespace_arn
  healthcheck_path = var.healthcheck_path
  environment_variables = merge({
    CARTS_DYNAMODB_TABLENAME = aws_dynamodb_table.dynamodb_carts.name
    SPRING_PROFILES_ACTIVE = "dynamodb"
  }, var.environment_variables)
  tasks_iam_role_policies = {
    Dynamodb_Access = aws_iam_policy.carts_dynamo.arn
  }
}