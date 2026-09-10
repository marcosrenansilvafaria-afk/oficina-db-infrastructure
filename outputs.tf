output "db_instance_endpoint" {
  description = "Endpoint completo (host:porta) da instância RDS."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "Hostname da instância RDS (sem a porta)."
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "Porta de conexão da instância RDS."
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "Nome do DB Subnet Group criado para o RDS."
  value       = aws_db_subnet_group.this.name
}

output "rds_security_group_id" {
  description = "ID do Security Group aplicado à instância RDS."
  value       = aws_security_group.rds.id
}

output "vpc_id" {
  description = "ID da VPC dedicada à infraestrutura de banco de dados."
  value       = aws_vpc.this.id
}

output "ssm_parameter_prefix" {
  description = "Prefixo dos parâmetros no SSM Parameter Store contendo as credenciais de conexão do banco (/oficina/<environment>/db/*)."
  value       = "/oficina/${var.environment}/db"
}
