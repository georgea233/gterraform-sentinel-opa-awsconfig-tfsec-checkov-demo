terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.33.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  # profile = var.aws_profile
}
# Replace this with your bucket name!

  