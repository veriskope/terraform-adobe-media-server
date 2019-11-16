# Configure the AWS Providers
provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
  alias = "usw2"
}

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-2"
  alias = "euw2"
}

# Bucket initially created using AWS CLI
#
# aws s3api create-bucket --bucket ams-terraform-backend-store \
#    --region us-west-2 \
#    --create-bucket-configuration \
#    LocationConstraint=us-west-2
#
# aws s3api put-bucket-encryption \
#     --bucket ams-terraform-backend-store \
#     --public-access-block-configuration '{
#       "BlockPublicAcls": true,
#       "IgnorePublicAcls": true,
#       "BlockPublicPolicy": true,
#       "RestrictPublicBuckets": true
#     }'
#     --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}
#
resource "aws_kms_key" "ams-key" {
  description             = "Custom key used for AMS AWS resources"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform-remote-state" {
  acl    = "private"
  bucket = "ams-terraform-remote-state.${data.aws_caller_identity.current.account_id}-${var.region}"
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.ams-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}

# dynamodb table for locking the state file
resource "aws_dynamodb_table" "terraform-state-lock" {
  name = "terraform-state-lock.${data.aws_caller_identity.current.account_id}-${var.region}"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "dynamodb-s3" {
  backend = "s3"
  config = {
    bucket  = "ams-terraform-remote-state.${data.aws_caller_identity.current.account_id}-${var.region}"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "${var.region}"
  }
}
