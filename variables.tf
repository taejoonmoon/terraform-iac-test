## Variables for root module
variable "aws_account_id" {
  description = "aws_account_id"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "default_tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  type        = map(string)
}

# variable "tags" {
#   description = "Specifies object tags key and value. This applies to all resources created by this module."
#   type        = map(string)
#   default     = {}
# }

# Variables for IAM
variable "iam_account_alias" {
  description = "iam account alias"
  type        = string
}
variable "admin_users" {
  description = "Create IAM Users"
  type        = list(any)
}

# Variables for s3
variable "cloudtrail_s3_bucket" {
  description = "cloudtrail s3 bucket"
  type        = string
}

variable "server_side_encryption_configuration" {
  description = "server_side_encryption_configuration"
  type        = any
  default     = {}
}

variable "lifecycle_rule" {
  description = "lifecycle_rule"
  type        = any
  default     = []
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "s3_bucket_acl" {
  description = "s3_bucket_acl"
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}


# Variables for cloudtrail
variable "cloudtrail_enabled" {
  description = "Boolean whether cloudtrail is enabled."
  type        = bool
  default     = true
}

variable "cloudtrail_name" {
  description = "The name of the trail."
  type        = string
  default     = "cloudtrail-multi-region"
}

variable "cloudtrail_cloudwatch_logs_enabled" {
  description = "Specifies whether the trail is delivered to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "cloudtrail_cloudwatch_logs_group_name" {
  description = "The name of CloudWatch Logs group to which CloudTrail events are delivered."
  type        = string
  default     = "cloudtrail-multi-region"
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain logs for. CIS recommends 365 days. Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely."
  type        = number
  default     = 365
}

variable "cloudtrail_iam_role_name" {
  description = "The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  type        = string
  default     = "CloudTrail-CloudWatch-Delivery-Role"
}

variable "cloudtrail_iam_role_policy_name" {
  description = "The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  type        = string
  default     = "CloudTrail-CloudWatch-Delivery-Policy"
}

variable "cloudtrail_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  type        = number
  default     = 10
}

# variable "cloudtrail_sns_topic_enabled" {
#   description = "Specifies whether the trail is delivered to a SNS topic."
#   type        = bool
#   default     = false
# }

# variable "cloudtrail_sns_topic_name" {
#   description = "The name of the SNS topic to link to the trail."
#   type        = string
#   default     = "cloudtrail-multi-region-sns-topic"
# }

# variable "cloudtrail_s3_key_prefix" {
#   description = "The prefix used when CloudTrail delivers events to the S3 bucket."
#   type        = string
#   default     = ""
# }

# variable "cloudtrail_s3_object_level_logging_buckets" {
#   description = "The list of S3 bucket ARNs on which to enable object-level logging."
#   type        = list(string)
#   default     = ["arn:aws:s3:::"] # All S3 buckets
# }

# variable "cloudtrail_dynamodb_event_logging_tables" {
#   description = "The list of DynamoDB table ARNs on which to enable event logging."
#   type        = list(string)
#   default     = ["arn:aws:dynamodb"] # All DynamoDB tables
# }

# variable "cloudtrail_lambda_invocation_logging_lambdas" {
#   description = "The list of lambda ARNs on which to enable invocation logging."
#   type        = list(string)
#   default     = ["arn:aws:lambda"] # All lambdas
# }

variable "event_selector" {
  description = "Specifies an event selector for enabling data event logging."
  type = list(object({
    include_management_events = bool
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))
  default = []
}

# Variables for sns
variable "sns_topic_enabled" {
  description = "Boolean whether chatbot is enabled."
  type        = bool
  default     = true
}

variable "cloudwatch_sns_topic_name" {
  description = "sns topic name for CloudWatch alert"
  type        = string
  default     = ""
}

variable "sns_topic_subscription_email" {
  description = "sns topic subscription email"
  type        = list(string)
  default     = []
}

# Variables for cloudwatch
variable "cis_alarms_enabled" {
  description = "Boolean cis alarms is enabled."
  type        = bool
  default     = true
}

variable "disabled_controls" {
  description = "List of IDs of disabled CIS controls"
  type        = list(string)
  default     = []
}

# Variables for chatbot
variable "chatbot_enabled" {
  description = "Boolean whether chatbot is enabled."
  type        = bool
  default     = true
}

variable "slack_configuration_name" {
  description = "slack configuration name"
  type        = string
  default     = ""
}

variable "slack_channel_id" {
  description = "slack channel id"
  type        = string
  default     = ""
}

variable "slack_workspace_id" {
  description = "slack_workspace_id"
  type        = string
  default     = ""
}

variable "chatbot_logging_level" {
  description = "chatbot_logging_level"
  type        = string
  default     = ""
}

variable "chatbot_iam_role_name" {
  description = "chatbot_iam_role_name"
  type        = string
  default     = ""
}

variable "chatbot_iam_role_policy_name" {
  description = "chatbot_iam_role_policy_name"
  type        = string
  default     = ""
}
