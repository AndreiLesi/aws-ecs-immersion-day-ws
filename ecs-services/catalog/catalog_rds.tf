module "catalog_rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.7.1"

  name                        = "${lower(var.project_name)}-catalog"
  engine                      = "aurora-mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.medium"
  allow_major_version_upgrade = true

  instances = {
    one = {
    }
  }

  vpc_id  = var.vpc_id
  subnets = var.subnet_ids
  db_subnet_group_name = "${lower(var.project_name)}-catalog"

  allowed_security_groups = concat(var.allowed_security_group_ids, [module.ecs_service.service_output.security_group_id])

  master_password        = random_string.catalog_db_master.result
  create_random_password = false
  database_name          = "catalog"
  storage_encrypted      = true
  apply_immediately      = true
  skip_final_snapshot    = true

  create_db_parameter_group = true
  db_parameter_group_name   = "${lower(var.project_name)}-catalog"
  db_parameter_group_family = "aurora-mysql8.0"

  create_db_cluster_parameter_group = true
  db_cluster_parameter_group_name   = "${lower(var.project_name)}-catalog"
  db_cluster_parameter_group_family = "aurora-mysql8.0"

}

resource "random_string" "catalog_db_master" {
  length  = 10
  special = false
}



resource "random_string" "random_catalog_secret" {
  length  = 4
  special = false
}

resource "aws_secretsmanager_secret" "catalog_db" {
  name       = "${var.project_name}-catalog-db-${random_string.random_catalog_secret.result}"
}

resource "aws_secretsmanager_secret_version" "catalog_db" {
  secret_id = aws_secretsmanager_secret.catalog_db.id

  secret_string = jsonencode(
    {
      username = module.catalog_rds.cluster_master_username
      password = module.catalog_rds.cluster_master_password
      host     = "${module.catalog_rds.cluster_endpoint}:${module.catalog_rds.cluster_port}"
    }
  )
}
