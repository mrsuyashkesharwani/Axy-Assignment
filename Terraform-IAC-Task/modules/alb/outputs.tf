# output "target_group_arn" {
#   value = module.alb.target_groups["backend"]
# }

output "alb_dns_name" {
  value = module.alb.dns_name
}

# output "backend_target_group_arn" {
#   value = one(values(module.alb.target_groups))
# }
