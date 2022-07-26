resource "aws_secretsmanager_secret" "rds-creds" {
  name = "${var.name}-rds-creds"
}
resource "aws_secretsmanager_secret_version" "rds-username" {
  secret_id     = aws_secretsmanager_secret.rds-creds.id
  secret_string = module.db.db_instance_username
}
resource "aws_secretsmanager_secret_version" "rds-password" {
  secret_id     = aws_secretsmanager_secret.rds-creds.id
  secret_string = module.db.db_instance_password
}