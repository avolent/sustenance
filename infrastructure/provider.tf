provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.deployment_version
      Project     = var.project_name
    }
  }
}