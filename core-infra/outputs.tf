output "cluster_arn" {
  value = module.ecs_cluster.arn
}

output "service_discovery_namespace_arn" {
  value = aws_service_discovery_private_dns_namespace.this.arn
}

output "vpc" {
  value = module.vpc
}