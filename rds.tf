resource "aws_db_instance" "this" {
  #checkov:skip=CKV_AWS_157: Multi-AZ dobra o custo da instancia (nao coberto integralmente pelo free tier). Aceito o risco de indisponibilidade em ambiente de estudo/demonstracao; usar var.multi_az=true em producao real.
  #checkov:skip=CKV_AWS_353: Performance Insights nao e suportado em db.t3.micro (memoria insuficiente) para a engine Postgres. Reavaliar ao subir de classe de instancia.
  #checkov:skip=CKV_AWS_118: Enhanced Monitoring exige role IAM adicional e gera custo de ingestao no CloudWatch Logs proporcional a granularidade. Fora de escopo para reduzir custo no free tier.
  identifier = "oficina-${var.environment}-db"

  engine         = "postgres"
  engine_version = var.db_engine_version

  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_master_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = false

  multi_az = var.multi_az

  iam_database_authentication_enabled = true
  auto_minor_version_upgrade          = true
  copy_tags_to_snapshot               = true
  enabled_cloudwatch_logs_exports     = ["postgresql", "upgrade"]

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection       = var.environment == "production"
  skip_final_snapshot       = var.environment != "production"
  final_snapshot_identifier = "oficina-${var.environment}-db-final-snapshot"
  apply_immediately         = false

  tags = {
    Name = "oficina-${var.environment}-db"
  }
}
