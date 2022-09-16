resource "aws_secretsmanager_secret" "rds-username" {
  name = "${var.env}-${var.name}-rds-user"
}
resource "aws_secretsmanager_secret" "rds-password" {
  name = "${var.env}-${var.name}-rds-password"
}
resource "aws_secretsmanager_secret_version" "rds-username" {
  secret_id     = aws_secretsmanager_secret.rds-username.id
  secret_string = module.db.db_instance_username
}
resource "aws_secretsmanager_secret_version" "rds-password" {
  secret_id     = aws_secretsmanager_secret.rds-password.id
  secret_string = module.db.db_instance_password
}