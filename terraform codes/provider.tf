terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }


  backend "s3" {
    bucket         = "shivu-upgrad-s3-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}
provider "aws" {
  # Configuration options
  region = "us-east-1"
}
