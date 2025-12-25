resource "aws_secretsmanager_secret" "db" {
  name = "app/postgres"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = "appuser"
    password = "apppass"
    dbname   = "appdb"
    host     = var.db_host
    port     = 5432
  })
}
