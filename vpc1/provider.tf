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
    bucket = "vpc1-state"
    key    = "path/to/vpc1"
    region = "us-east-1"
  }
*/

provider "aws" {
  region = "us-east-1"
}