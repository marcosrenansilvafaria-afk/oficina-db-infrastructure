provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "oficina"
      Component   = "database-infrastructure"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
