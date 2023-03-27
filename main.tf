terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

resource "random_id" "aap_id" {
  byte_length = 2
}
