## AWS 설정

- AWS Account : sample
- Account ID: sample
- IAM Alias : https://sample.signin.aws.amazon.com/console

Terraform IAM User : terraform

```
export AWS_PROFILE=sample
```

## terraform 통해서 group, user 생성

```
terraform init
terraform validate
terraform plan
terraform apply
```

## user 비밀번호 설정

user 생성 후 일회용 비밀번호 만들어서 사용자에게 전달을 해야 한다. 이 부분은 IAC로 관리하기 힘든 부분이다.
굳이 IAC로 하겠다면 pgp 이용하여 처리를 할 수 있기는 하다. 그런데 이 경우에도 해당 사용자가 비밀번호를 바로 바꾸어야 하므로 굳이 iac에서 관리하는 것이 불필요한 부분이다.

https://docs.aws.amazon.com/cli/latest/reference/iam/create-login-profile.html

```
iam_user="tjmoon"
iam_user_password=`openssl rand -base64 32`
aws iam create-login-profile --user-name $iam_user --password $iam_user_password --password-reset-required
echo $iam_user_password
```

## CloudTrail and CloudWatch

AWS 이벤트를 기록하기 위하여 CloudTrail 설정 및 CloudWatch 로그 그룹에 전송 [CloudTrail 모듈](modules/cloudtrail)

- https://github.com/nozaq/terraform-aws-secure-baseline/tree/main/modules/cloudtrail-baseline 소스 코드의 내용 일부 수정하여 사용

CloudTrail 를 위한 s3 bucket 생성

CloudWatch 알람을 위해 SNS 설정

CIS AWS Foundations Controls 보안 관련 정보 알람

- https://github.com/terraform-aws-modules/terraform-aws-cloudwatch/tree/v3.2.0/modules/cis-alarms

slack 채널 연동을 위한 AWS chatbot 구성

- https://github.com/waveaccounting/terraform-aws-chatbot-slack-configuration
- slack에서 필요한 채널 생성. (공개 또는 비공개)을 하고 app 에서 AWS chatbot을 추가해 줌.
- 콘솔 - AWS Chatbot 에서 클라이언트로 Slack을 추가. (Slack Workspace 생성이 됨)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.2.0 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.11.0  |

## Modules

| Name                                                                                                                 | Source                                                   | Version |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- | ------- |
| <a name="module_chatbot_slack_configuration"></a> [chatbot_slack_configuration](#module_chatbot_slack_configuration) | waveaccounting/chatbot-slack-configuration/aws           | 1.1.0   |
| <a name="module_cis_alarms"></a> [cis_alarms](#module_cis_alarms)                                                    | terraform-aws-modules/cloudwatch/aws//modules/cis-alarms | ~> 3.0  |
| <a name="module_cloudtrail"></a> [cloudtrail](#module_cloudtrail)                                                    | github.com/taejoonmoon/terraform-aws-cloudtrail-baseline | v0.1.0  |
| <a name="module_s3_bucket"></a> [s3_bucket](#module_s3_bucket)                                                       | terraform-aws-modules/s3-bucket/aws                      | v3.1.0  |

## Resources

| Name                                                                                                                                                               | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_iam_account_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias)                                       | resource    |
| [aws_iam_group.administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group)                                               | resource    |
| [aws_iam_group_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment)           | resource    |
| [aws_iam_policy.chatbot_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_role.chatbot_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                            | resource    |
| [aws_iam_role_policy_attachment.chatbot_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_user.admin_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)                                                   | resource    |
| [aws_iam_user_group_membership.grp_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership)                     | resource    |
| [aws_sns_topic.cloudwatch_alarms_for_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                            | resource    |
| [aws_sns_topic_policy.alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy)                                        | resource    |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)                             | resource    |
| [aws_sns_topic_subscription.slack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)                             | resource    |
| [aws_iam_policy_document.alarms_sns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                    | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                        | data source |
| [aws_iam_policy_document.chatbot_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                | data source |
| [aws_iam_policy_document.chatbot_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |

## Inputs

| Name                                                                                                                                                | Description                                                                                                                                                                                            | Type                                                                                                                                                                                         | Default                                   | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- | :------: |
| <a name="input_admin_users"></a> [admin_users](#input_admin_users)                                                                                  | Create IAM Users                                                                                                                                                                                       | `list(any)`                                                                                                                                                                                  | n/a                                       |   yes    |
| <a name="input_aws_account_id"></a> [aws_account_id](#input_aws_account_id)                                                                         | aws_account_id                                                                                                                                                                                         | `string`                                                                                                                                                                                     | n/a                                       |   yes    |
| <a name="input_block_public_acls"></a> [block_public_acls](#input_block_public_acls)                                                                | Whether Amazon S3 should block public ACLs for this bucket.                                                                                                                                            | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_block_public_policy"></a> [block_public_policy](#input_block_public_policy)                                                          | Whether Amazon S3 should block public bucket policies for this bucket.                                                                                                                                 | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_chatbot_enabled"></a> [chatbot_enabled](#input_chatbot_enabled)                                                                      | Boolean whether chatbot is enabled.                                                                                                                                                                    | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_chatbot_iam_role_name"></a> [chatbot_iam_role_name](#input_chatbot_iam_role_name)                                                    | chatbot_iam_role_name                                                                                                                                                                                  | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_chatbot_iam_role_policy_name"></a> [chatbot_iam_role_policy_name](#input_chatbot_iam_role_policy_name)                               | chatbot_iam_role_policy_name                                                                                                                                                                           | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_chatbot_logging_level"></a> [chatbot_logging_level](#input_chatbot_logging_level)                                                    | chatbot_logging_level                                                                                                                                                                                  | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_cis_alarms_enabled"></a> [cis_alarms_enabled](#input_cis_alarms_enabled)                                                             | Boolean cis alarms is enabled.                                                                                                                                                                         | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_cloudtrail_cloudwatch_logs_enabled"></a> [cloudtrail_cloudwatch_logs_enabled](#input_cloudtrail_cloudwatch_logs_enabled)             | Specifies whether the trail is delivered to CloudWatch Logs.                                                                                                                                           | `bool`                                                                                                                                                                                       | `false`                                   |    no    |
| <a name="input_cloudtrail_cloudwatch_logs_group_name"></a> [cloudtrail_cloudwatch_logs_group_name](#input_cloudtrail_cloudwatch_logs_group_name)    | The name of CloudWatch Logs group to which CloudTrail events are delivered.                                                                                                                            | `string`                                                                                                                                                                                     | `"cloudtrail-multi-region"`               |    no    |
| <a name="input_cloudtrail_enabled"></a> [cloudtrail_enabled](#input_cloudtrail_enabled)                                                             | Boolean whether cloudtrail is enabled.                                                                                                                                                                 | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_cloudtrail_iam_role_name"></a> [cloudtrail_iam_role_name](#input_cloudtrail_iam_role_name)                                           | The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group.                                                                                                           | `string`                                                                                                                                                                                     | `"CloudTrail-CloudWatch-Delivery-Role"`   |    no    |
| <a name="input_cloudtrail_iam_role_policy_name"></a> [cloudtrail_iam_role_policy_name](#input_cloudtrail_iam_role_policy_name)                      | The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group.                                                                                                    | `string`                                                                                                                                                                                     | `"CloudTrail-CloudWatch-Delivery-Policy"` |    no    |
| <a name="input_cloudtrail_key_deletion_window_in_days"></a> [cloudtrail_key_deletion_window_in_days](#input_cloudtrail_key_deletion_window_in_days) | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days.                                                                 | `number`                                                                                                                                                                                     | `10`                                      |    no    |
| <a name="input_cloudtrail_name"></a> [cloudtrail_name](#input_cloudtrail_name)                                                                      | The name of the trail.                                                                                                                                                                                 | `string`                                                                                                                                                                                     | `"cloudtrail-multi-region"`               |    no    |
| <a name="input_cloudtrail_s3_bucket"></a> [cloudtrail_s3_bucket](#input_cloudtrail_s3_bucket)                                                       | cloudtrail s3 bucket                                                                                                                                                                                   | `string`                                                                                                                                                                                     | n/a                                       |   yes    |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch_logs_retention_in_days](#input_cloudwatch_logs_retention_in_days)                | Number of days to retain logs for. CIS recommends 365 days. Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely. | `number`                                                                                                                                                                                     | `365`                                     |    no    |
| <a name="input_cloudwatch_sns_topic_name"></a> [cloudwatch_sns_topic_name](#input_cloudwatch_sns_topic_name)                                        | sns topic name for CloudWatch alert                                                                                                                                                                    | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_default_tags"></a> [default_tags](#input_default_tags)                                                                               | Specifies object tags key and value. This applies to all resources created by this module.                                                                                                             | `map(string)`                                                                                                                                                                                | n/a                                       |   yes    |
| <a name="input_disabled_controls"></a> [disabled_controls](#input_disabled_controls)                                                                | List of IDs of disabled CIS controls                                                                                                                                                                   | `list(string)`                                                                                                                                                                               | `[]`                                      |    no    |
| <a name="input_event_selector"></a> [event_selector](#input_event_selector)                                                                         | Specifies an event selector for enabling data event logging.                                                                                                                                           | <pre>list(object({<br> include_management_events = bool<br> read_write_type = string<br><br> data_resource = list(object({<br> type = string<br> values = list(string)<br> }))<br> }))</pre> | `[]`                                      |    no    |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy)                                                                            | (Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.                | `bool`                                                                                                                                                                                       | `false`                                   |    no    |
| <a name="input_iam_account_alias"></a> [iam_account_alias](#input_iam_account_alias)                                                                | iam account alias                                                                                                                                                                                      | `string`                                                                                                                                                                                     | n/a                                       |   yes    |
| <a name="input_ignore_public_acls"></a> [ignore_public_acls](#input_ignore_public_acls)                                                             | Whether Amazon S3 should ignore public ACLs for this bucket.                                                                                                                                           | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_lifecycle_rule"></a> [lifecycle_rule](#input_lifecycle_rule)                                                                         | lifecycle_rule                                                                                                                                                                                         | `any`                                                                                                                                                                                        | `[]`                                      |    no    |
| <a name="input_region"></a> [region](#input_region)                                                                                                 | region                                                                                                                                                                                                 | `string`                                                                                                                                                                                     | n/a                                       |   yes    |
| <a name="input_restrict_public_buckets"></a> [restrict_public_buckets](#input_restrict_public_buckets)                                              | Whether Amazon S3 should restrict public bucket policies for this bucket.                                                                                                                              | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_s3_bucket_acl"></a> [s3_bucket_acl](#input_s3_bucket_acl)                                                                            | s3_bucket_acl                                                                                                                                                                                          | `string`                                                                                                                                                                                     | `"private"`                               |    no    |
| <a name="input_server_side_encryption_configuration"></a> [server_side_encryption_configuration](#input_server_side_encryption_configuration)       | server_side_encryption_configuration                                                                                                                                                                   | `any`                                                                                                                                                                                        | `{}`                                      |    no    |
| <a name="input_slack_channel_id"></a> [slack_channel_id](#input_slack_channel_id)                                                                   | slack channel id                                                                                                                                                                                       | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_slack_configuration_name"></a> [slack_configuration_name](#input_slack_configuration_name)                                           | slack configuration name                                                                                                                                                                               | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_slack_workspace_id"></a> [slack_workspace_id](#input_slack_workspace_id)                                                             | slack_workspace_id                                                                                                                                                                                     | `string`                                                                                                                                                                                     | `""`                                      |    no    |
| <a name="input_sns_topic_enabled"></a> [sns_topic_enabled](#input_sns_topic_enabled)                                                                | Boolean whether chatbot is enabled.                                                                                                                                                                    | `bool`                                                                                                                                                                                       | `true`                                    |    no    |
| <a name="input_sns_topic_subscription_email"></a> [sns_topic_subscription_email](#input_sns_topic_subscription_email)                               | sns topic subscription email                                                                                                                                                                           | `list(string)`                                                                                                                                                                               | `[]`                                      |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
