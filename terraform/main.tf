provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}


terraform {
  backend "s3" {
    bucket = "elviskemayo-bucket"
    key    = "bucket-test"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "s3Bucket" {
  bucket = "obirene"
  acl    = "public-read"

  policy = <<EOF
{
  "Id": "MakePublic",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::obirene/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}