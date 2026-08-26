# -----------------------------------------------------------------------------
# Geral
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente (ex: production, staging, development). Usado em tags e identificadores de recursos."
  type        = string
  default     = "production"
}

# -----------------------------------------------------------------------------
# Rede
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC dedicada à infraestrutura de banco de dados."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "Blocos CIDR das subnets privadas (uma por AZ) usadas pelo DB Subnet Group do RDS."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability Zones onde as subnets privadas serão criadas. Deve ter o mesmo tamanho de private_subnet_cidrs."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "k8s_cluster_cidr_blocks" {
  description = <<-EOT
    Blocos CIDR de origem do cluster Kubernetes (Repositório 2/3 da Fase 3) autorizados
    a acessar o RDS na porta 5432. PLACEHOLDER: substitua pelo CIDR real do VPC/subnets
    do cluster Kubernetes ao integrar este repositório com o de infraestrutura de compute.
  EOT
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "auth_lambda_cidr_blocks" {
  description = <<-EOT
    Blocos CIDR de origem da Lambda de autenticação (Repositório 4 da Fase 3) autorizados
    a acessar o RDS na porta 5432. PLACEHOLDER: substitua pelo CIDR real da VPC da Lambda.
  EOT
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

# -----------------------------------------------------------------------------
# Banco de dados
# -----------------------------------------------------------------------------

variable "db_name" {
  description = "Nome do banco de dados inicial criado na instância RDS."
  type        = string
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário master do RDS. Não é um segredo por si só, mas evite valores óbvios em produção real."
  type        = string
  default     = "oficina_admin"
}

variable "db_master_password" {
  description = "Senha master do RDS. NUNCA definir default nem preencher em .tfvars — fornecer via variável de ambiente TF_VAR_db_master_password (local) ou GitHub Secrets (CI/CD)."
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "Versão do engine PostgreSQL no RDS."
  type        = string
  default     = "16.4"
}

variable "db_instance_class" {
  description = "Classe de instância do RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento inicial alocado (GB)."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Limite máximo de armazenamento para autoscaling de storage do RDS (GB)."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Número de dias de retenção dos backups automáticos."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Janela diária (UTC) para execução de backups automáticos."
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Janela semanal (UTC) para manutenção da instância."
  type        = string
  default     = "mon:04:30-mon:05:30"
}

variable "multi_az" {
  description = "Habilita implantação Multi-AZ (alta disponibilidade). Recomendado 'true' em produção real; 'false' por padrão para reduzir custo em ambientes de estudo/demonstração."
  type        = bool
  default     = false
}
