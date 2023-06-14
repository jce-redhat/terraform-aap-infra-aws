terraform {
  required_version = ">= 1.2.0"

  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  # configure during init with `terraform init -backend-config=config.s3.tfbackend`
  backend "s3" {}
}

provider "aws" {
  region = var.aap_aws_region
}

resource "random_id" "aap_id" {
  byte_length = 2
}
