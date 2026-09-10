# Publica as credenciais de conexao no AWS Systems Manager Parameter Store
# (SecureString, sem custo no tier Standard) para que outras aplicacoes
# (Lambda de autenticacao, workloads no cluster Kubernetes via IRSA) leiam a
# credencial em runtime, em vez de recebe-la espalhada em variaveis de
# ambiente de multiplos repositorios.
#
# Optamos por SSM Parameter Store em vez de AWS Secrets Manager para evitar o
# custo fixo de ~US$0.40/segredo/mes do Secrets Manager, que nao e coberto
# pelo free tier.

resource "aws_ssm_parameter" "db_username" {
  name        = "/oficina/${var.environment}/db/username"
  description = "Usuario master do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = var.db_username

  tags = {
    Name = "oficina-${var.environment}-db-username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/oficina/${var.environment}/db/password"
  description = "Senha master do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = var.db_master_password

  tags = {
    Name = "oficina-${var.environment}-db-password"
  }
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/oficina/${var.environment}/db/host"
  description = "Endereco do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = aws_db_instance.this.address

  tags = {
    Name = "oficina-${var.environment}-db-host"
  }
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/oficina/${var.environment}/db/port"
  description = "Porta do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = tostring(aws_db_instance.this.port)

  tags = {
    Name = "oficina-${var.environment}-db-port"
  }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/oficina/${var.environment}/db/dbname"
  description = "Nome do banco de dados do projeto oficina"
  type        = "SecureString"
  value       = var.db_name

  tags = {
    Name = "oficina-${var.environment}-db-dbname"
  }
}
