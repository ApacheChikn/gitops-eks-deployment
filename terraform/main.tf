# provider "aws" {
#   version = "~> 2.0"
#   region  = "us-east-1"
# }


# terraform {
#   backend "s3" {
#     bucket = "lov-rene-n2"
#     key    = "bucket-test"
#     region = "us-east-1"
#   }
# }

# resource "aws_s3_bucket" "s3Bucket" {
#   bucket = "obirene"
#   acl    = "public-read"

#   policy = <<EOF
# {
#   "Id": "MakePublic",
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:s3:::obirene/*",
#       "Principal": "*"
#     }
#   ]
# }
# EOF

#   website {
#     index_document = "index.html"
#   }
# }

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "gitops-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}