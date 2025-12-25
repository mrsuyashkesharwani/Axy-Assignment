module "vpc" {
  source = "./modules/vpc"
}

module "secrets" {
  source  = "./modules/secrets"
  db_host = module.rds.db_endpoint
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.security_groups.alb_sg_id
  certificate_arn = var.acm_certificate_arn
}

module "rds" {
  source          = "./modules/rds"
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.security_groups.db_sg_id
}

module "ecs" {
  source           = "./modules/ecs"
  private_subnets  = module.vpc.private_subnets
  backend_sg_id    = module.security_groups.backend_sg_id
  db_secret_arn   = module.secrets.db_secret_arn
  backend_image    = var.backend_image
  db_endpoint      = module.rds.db_endpoint
}
