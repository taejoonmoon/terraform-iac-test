locals {
  bucket_name    = var.cloudtrail_s3_bucket
  aws_account_id = var.aws_account_id
}

## cloudtrail
module "cloudtrail" {
  count = var.cloudtrail_enabled ? 1 : 0

  source = "github.com/taejoonmoon/terraform-aws-cloudtrail-baseline?ref=v0.1.0"

  aws_account_id                    = var.aws_account_id
  cloudtrail_name                   = var.cloudtrail_name
  cloudwatch_logs_enabled           = var.cloudtrail_cloudwatch_logs_enabled
  cloudwatch_logs_group_name        = var.cloudtrail_cloudwatch_logs_group_name
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  iam_role_name                     = var.cloudtrail_iam_role_name
  iam_role_policy_name              = var.cloudtrail_iam_role_policy_name
  key_deletion_window_in_days       = var.cloudtrail_key_deletion_window_in_days
  region                            = var.region
  s3_bucket_name                    = var.cloudtrail_s3_bucket
  event_selector                    = var.event_selector

  # tags = var.tags
}



data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck20150319"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }

  statement {
    sid = "AWSCloudTrailWrite20150319"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/AWSLogs/${local.aws_account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }
  }

}


module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.1.0"

  create_bucket = var.cloudtrail_enabled ? true : false

  bucket = var.cloudtrail_s3_bucket

  force_destroy = var.force_destroy
  acl           = var.s3_bucket_acl

  # Bucket policies
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  server_side_encryption_configuration = var.server_side_encryption_configuration

  lifecycle_rule = var.lifecycle_rule

}