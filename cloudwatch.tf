## sns_topic
locals {
  sns_topic_arn = var.cloudtrail_enabled && var.sns_topic_enabled ? aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn : ""
}

resource "aws_sns_topic" "cloudwatch_alarms_for_cloudtrail" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled ? 1 : 0

  name = var.cloudwatch_sns_topic_name
}

resource "aws_sns_topic_policy" "alarms" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled ? 1 : 0

  arn    = aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn
  policy = data.aws_iam_policy_document.alarms_sns_policy.json
}

data "aws_iam_policy_document" "alarms_sns_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.aws_account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${local.sns_topic_arn}",
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_subscription" "email" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled ? length(var.sns_topic_subscription_email) : 0

  topic_arn = aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn
  protocol  = "email"
  endpoint  = var.sns_topic_subscription_email[count.index]
}

resource "aws_sns_topic_subscription" "slack" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.chatbot_enabled ? 1 : 0

  topic_arn = aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn
  protocol  = "https"
  endpoint  = "https://global.sns-api.chatbot.amazonaws.com"
}

## cis alarms
module "cis_alarms" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.cis_alarms_enabled ? 1 : 0

  source  = "terraform-aws-modules/cloudwatch/aws//modules/cis-alarms"
  version = "~> 3.0"

  log_group_name    = var.cloudtrail_cloudwatch_logs_group_name
  alarm_actions     = [aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn]
  disabled_controls = var.disabled_controls
  # control_overrides = {
  #   SecurityGroupChanges = {
  #     pattern     = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  #     description = "Monitoring changes to security group will help ensure that resources and services are not unintentionally exposed."
  #     period = 600
  #   }
  # }
}

## chatbot
data "aws_iam_policy_document" "chatbot_assume_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "chatbot_cloudwatch" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.chatbot_enabled ? 1 : 0

  name_prefix        = var.chatbot_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume_policy.json
}

data "aws_iam_policy_document" "chatbot_cloudwatch_policy" {
  statement {
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "chatbot_cloudwatch_policy" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.chatbot_enabled ? 1 : 0

  name_prefix = var.chatbot_iam_role_policy_name
  path        = "/"
  policy      = data.aws_iam_policy_document.chatbot_cloudwatch_policy.json
}

resource "aws_iam_role_policy_attachment" "chatbot_cloudwatch_policy" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.chatbot_enabled ? 1 : 0

  role       = aws_iam_role.chatbot_cloudwatch[0].id
  policy_arn = aws_iam_policy.chatbot_cloudwatch_policy[0].arn
}


module "chatbot_slack_configuration" {
  count = var.cloudtrail_enabled && var.sns_topic_enabled && var.chatbot_enabled ? 1 : 0

  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.1.0"

  configuration_name = var.slack_configuration_name
  iam_role_arn       = aws_iam_role.chatbot_cloudwatch[0].arn
  logging_level      = var.chatbot_logging_level
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id

  sns_topic_arns = [
    aws_sns_topic.cloudwatch_alarms_for_cloudtrail[0].arn,
  ]
}

