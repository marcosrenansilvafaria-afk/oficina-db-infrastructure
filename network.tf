# -----------------------------------------------------------------------------
# VPC dedicada à infraestrutura de banco de dados
# -----------------------------------------------------------------------------

#checkov:skip=CKV2_AWS_11: VPC Flow Logs gera custo de ingestao/armazenamento (CloudWatch Logs ou S3) proporcional ao trafego. Fora de escopo para reduzir custo no free tier.
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "oficina-${var.environment}-db-vpc"
  }
}

# Restringe todo trafego do Security Group padrao da VPC (criado automaticamente
# pela AWS). Nenhuma regra e adicionada aqui de proposito - o SG padrao nao deve
# ser usado por nenhum recurso.
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "oficina-${var.environment}-db-vpc-default-sg-locked"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "oficina-${var.environment}-db-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "oficina-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "oficina-${var.environment}-db-subnet-group"
  }
}

# -----------------------------------------------------------------------------
# Security Group — acesso restrito apenas ao cluster Kubernetes e à Lambda de auth
# -----------------------------------------------------------------------------

resource "aws_security_group" "rds" {
  name        = "oficina-${var.environment}-rds-sg"
  description = "Permite trafego PostgreSQL apenas das subnets do cluster Kubernetes e da Lambda de autenticacao"
  vpc_id      = aws_vpc.this.id

  # Security Groups sao stateful: respostas a trafego de ingress permitido nao
  # exigem regra de egress correspondente. Removemos explicitamente a regra de
  # egress "allow all" que a AWS cria por padrao, ja que o RDS nao precisa
  # iniciar conexoes de saida.
  egress = []

  tags = {
    Name = "oficina-${var.environment}-rds-sg"
  }
}

resource "aws_security_group_rule" "rds_ingress_k8s_cluster" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.k8s_cluster_cidr_blocks
  security_group_id = aws_security_group.rds.id
  description       = "Acesso PostgreSQL a partir do cluster Kubernetes"
}

resource "aws_security_group_rule" "rds_ingress_auth_lambda" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.auth_lambda_cidr_blocks
  security_group_id = aws_security_group.rds.id
  description       = "Acesso PostgreSQL a partir da Lambda de autenticacao"
}

# -----------------------------------------------------------------------------
# Parameter Group — parametros de seguranca/performance do PostgreSQL
# -----------------------------------------------------------------------------

resource "aws_db_parameter_group" "this" {
  name   = "oficina-${var.environment}-postgres16"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "oficina-${var.environment}-postgres16-params"
  }
}
