## cloudwatch agent
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_common_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# CloudWatch agent : CloudWatchAgentPutLogsRetention
resource "aws_iam_policy" "put_retention_policy" {
  name = "CloudWatchAgentPutLogsRetention"
  path = "/"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:PutRetentionPolicy",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_put_retention_policy" {
  role       = aws_iam_role.ec2_common_role.name
  policy_arn = aws_iam_policy.put_retention_policy.arn
}


resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = var.param_cw_agent
  type        = "String"
  value       = file("files/cw_agent_config.json")
}

resource "aws_cloudwatch_log_group" "cw_agent" {
  count             = 1
  name              = var.cloudwatch_logs_group_name
  retention_in_days = var.cloudwatch_logs_retention_in_days

}
