module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "app-postgres"
  engine     = "postgres"
  family = "postgres15"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  multi_az          = true

  db_name  = "appdb"
  username = "appuser"
  password = "apppass"

  subnet_ids             = var.private_subnets
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible    = false
}
