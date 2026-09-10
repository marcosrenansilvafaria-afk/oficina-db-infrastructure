# Publica as credenciais de conexao no AWS Systems Manager Parameter Store
# (SecureString, sem custo no tier Standard) para que outras aplicacoes
# (Lambda de autenticacao, workloads no cluster Kubernetes via IRSA) leiam a
# credencial em runtime, em vez de recebe-la espalhada em variaveis de
# ambiente de multiplos repositorios.
#
# Optamos por SSM Parameter Store em vez de AWS Secrets Manager para evitar o
# custo fixo de ~US$0.40/segredo/mes do Secrets Manager, que nao e coberto
# pelo free tier.
#
# Os parametros usam a chave KMS gerenciada pela AWS (aws/ssm), que e gratuita.
# Uma CMK (Customer Managed Key) teria custo mensal fixo adicional por chave,
# entao optamos por nao usar CMK para reduzir custo no free tier.

resource "aws_ssm_parameter" "db_username" {
  #checkov:skip=CKV_AWS_337: Chave KMS gerenciada pela AWS (aws/ssm) e gratuita; CMK customizada tem custo mensal adicional.
  name        = "/oficina/${var.environment}/db/username"
  description = "Usuario master do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = var.db_username

  tags = {
    Name = "oficina-${var.environment}-db-username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  #checkov:skip=CKV_AWS_337: Chave KMS gerenciada pela AWS (aws/ssm) e gratuita; CMK customizada tem custo mensal adicional.
  name        = "/oficina/${var.environment}/db/password"
  description = "Senha master do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = var.db_master_password

  tags = {
    Name = "oficina-${var.environment}-db-password"
  }
}

resource "aws_ssm_parameter" "db_host" {
  #checkov:skip=CKV_AWS_337: Chave KMS gerenciada pela AWS (aws/ssm) e gratuita; CMK customizada tem custo mensal adicional.
  name        = "/oficina/${var.environment}/db/host"
  description = "Endereco do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = aws_db_instance.this.address

  tags = {
    Name = "oficina-${var.environment}-db-host"
  }
}

resource "aws_ssm_parameter" "db_port" {
  #checkov:skip=CKV_AWS_337: Chave KMS gerenciada pela AWS (aws/ssm) e gratuita; CMK customizada tem custo mensal adicional.
  name        = "/oficina/${var.environment}/db/port"
  description = "Porta do RDS PostgreSQL do projeto oficina"
  type        = "SecureString"
  value       = tostring(aws_db_instance.this.port)

  tags = {
    Name = "oficina-${var.environment}-db-port"
  }
}

resource "aws_ssm_parameter" "db_name" {
  #checkov:skip=CKV_AWS_337: Chave KMS gerenciada pela AWS (aws/ssm) e gratuita; CMK customizada tem custo mensal adicional.
  name        = "/oficina/${var.environment}/db/dbname"
  description = "Nome do banco de dados do projeto oficina"
  type        = "SecureString"
  value       = var.db_name

  tags = {
    Name = "oficina-${var.environment}-db-dbname"
  }
}
