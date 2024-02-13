terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_demo" {
  bucket        = var.aws_s3_bucket_name
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
    id     = "example-rule"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

resource "aws_redshift_cluster" "tf_redshift_demo" {
  cluster_identifier        = "tf-redshift-cluster"
  database_name             = "mydb"
  master_username           = "dtaa"
  master_password           = "Dtaa0673."
  node_type                 = "ra3.xlplus"
  cluster_type              = "single-node"
  final_snapshot_identifier = "my-final-snapshot"
}
