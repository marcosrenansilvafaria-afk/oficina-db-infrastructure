# Backend remoto (S3 + DynamoDB lock).
#
# O bucket S3 e a tabela DynamoDB abaixo NÃO são gerenciados por este Terraform
# (problema de "chicken-and-egg": o backend precisa existir antes do `terraform init`).
# Eles devem ser criados uma única vez via bootstrap manual — ver README.md, seção
# "Bootstrap do backend remoto".
#
# Os valores reais de bucket/region/dynamodb_table são passados no `terraform init`
# via `-backend-config` (local) ou já resolvidos no workflow de CI/CD, para evitar
# hardcode de nomes de bucket específicos de conta/ambiente neste arquivo versionado.
terraform {
  backend "s3" {
    key            = "oficina-db/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "oficina-db-terraform-locks"
  }
}
