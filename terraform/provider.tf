terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }

  required_version = "~> 1.0"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

terraform {
  backend "s3" {
    bucket = "eks-test-bucket2"
    key    = "bucket-test"
    region = "us-east-1"
  }
}