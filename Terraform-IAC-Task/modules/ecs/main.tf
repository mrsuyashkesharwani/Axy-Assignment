module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.11.0"

  cluster_name = "ecs-cluster"

  services = {
    backend = {
      cpu    = 512
      memory = 1024

      container_definitions = {
        backend = {
          image = var.backend_image
          portMappings = [{ containerPort = 5000 }]
          secrets = [
            {
              name      = "DB_SECRET"
              valueFrom = var.db_secret_arn
            }
          ]
        }
      }

      subnet_ids         = var.private_subnets
      security_group_ids = [var.backend_sg_id]
      assign_public_ip   = false

      load_balancer = {
        service = {
          # target_group_arn = var.target_group_arn
          container_name   = "backend"
          container_port   = 5000
        }
      }
    }
  }
}
