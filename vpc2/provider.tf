terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

/*
  backend "s3" {
    bucket = "vpc2-state"
    key    = "path/to/vpc2"
    region = "us-east-1"
  }
*/

provider "aws" {
  region = "us-east-1"
}