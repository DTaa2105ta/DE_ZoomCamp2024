terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_demo" {
  bucket = "dtaa-de-tf"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
    bucket = aws_s3_bucket.terraform_demo.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_bucket_lifecycle_rule" {
  bucket = aws_s3_bucket.terraform_demo.bucket

  rule {
    id = "example-rule"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

