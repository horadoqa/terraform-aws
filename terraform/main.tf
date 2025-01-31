terraform {

  required_version = "1.10.5"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~>5.84.0"
    }
  }

  backend "s3" {
    bucket = "tfstate-bucket-horadoqa"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.aws_region
}
