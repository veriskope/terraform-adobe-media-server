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
#     --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}
#

data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket  = "ams-terraform-backend-store"
    encrypt = true
    key     = "terraform/terraform.tfstate"
    region  = "us-west-2"
  }
}
