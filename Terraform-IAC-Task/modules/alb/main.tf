module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.4.0"

  name    = "ecs-alb"
  vpc_id = var.vpc_id
  subnets = var.public_subnets
  security_groups = [var.alb_sg_id]
  
  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      # certificate_arn = var.certificate_arn
      forward = {
        target_group_key = "backend"
      }
    }
  }

  target_groups = {
    backend = {
      port        = 5000
      protocol    = "HTTP"
      target_type = "ip"
      create_attachment = false
      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/api/health"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  }
}
