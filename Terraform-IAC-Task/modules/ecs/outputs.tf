output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.ecs_service.cluster_arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.ecs_service.cluster_id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.ecs_service.cluster_name
}