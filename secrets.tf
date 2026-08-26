# Publica as credenciais de conexao no AWS Secrets Manager para que outras
# aplicacoes (Lambda de autenticacao, workloads no cluster Kubernetes via
# External Secrets Operator / IRSA) leiam a credencial em runtime, em vez de
# recebe-la espalhada em variaveis de ambiente de multiplos repositorios.

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "oficina/${var.environment}/db-credentials"
  description = "Credenciais de conexao com o RDS PostgreSQL do projeto oficina"

  tags = {
    Name = "oficina-${var.environment}-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_master_password
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = var.db_name
  })
}
