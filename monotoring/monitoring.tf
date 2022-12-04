# https://github.com/terraform-aws-modules/terraform-aws-cloudwatch/blob/v3.2.0/modules/cis-alarms/main.tf
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm


data "aws_sns_topic" "sns" {
  name = "CloudWatchAlarmsForCloudTrail"
}

resource "aws_cloudwatch_metric_alarm" "cpu_user_test" {
  actions_enabled     = "true"
  alarm_actions       = [data.aws_sns_topic.sns.arn]
  alarm_description   = "cpu user test"
  alarm_name          = "cpu_user_test"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = "3"

  dimensions = {
    InstanceId = aws_instance.tjtest[0].id
  }

  evaluation_periods = "5"
  metric_name        = "cpu_usage_user"
  namespace          = "CWAgent"
  period             = "60"
  statistic          = "Average"
  threshold          = "50"
  treat_missing_data = "breaching"

}

resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_Alarm" {
  alarm_name = "EC2_CPU_Usage_Alarm"

  dimensions = {
    InstanceId = aws_instance.tjtest[0].id
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization exceeding 70%"
}


resource "aws_cloudwatch_metric_alarm" "NetworkPacketsIn" {
  alarm_name          = "NetworkPacketsIn"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "NetworkPacketsIn"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "1000"
  alarm_description   = "모든 네트워크 인터페이스에서 인스턴스가 받은 바이트 수"
}


resource "aws_cloudwatch_composite_alarm" "EC2_and_Networks" {
  alarm_description = "Composite alarm that monitors CPUUtilization and NetworkPacketsIn"
  alarm_name        = "EC2_&Network_Composite_Alarm"
  alarm_actions     = [data.aws_sns_topic.sns.arn]

  alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.EC2_CPU_Usage_Alarm.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.NetworkPacketsIn.alarm_name})"


  depends_on = [
    aws_cloudwatch_metric_alarm.EC2_CPU_Usage_Alarm,
    aws_cloudwatch_metric_alarm.NetworkPacketsIn,
  ]
}

resource "aws_cloudwatch_dashboard" "EC2_Dashboard" {
  dashboard_name = "EC2-Dashboard"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "width": 24,
            "height": 15,
            "x": 0,
            "y": 0,
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::EC2::Instance",
                        "stat": "Maximum"
                    }
                ],
                "aggregateBy": {
                    "key": "InstanceType",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "State",
                        "value": "running"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "rowsPerPage": 8,
                    "widgetsPerRow": 2
                },
                "period": 60,
                "title": "Running EC2 Instances CPUUtilization"
            }
        }
    ]
}
EOF
}


resource "aws_route53_health_check" "example" {
  count             = 0
  fqdn              = "amazon.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "tf-test-health-check"
  }
}
