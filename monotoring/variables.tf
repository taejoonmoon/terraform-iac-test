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

variable "create" {
  description = "Boolean"
  type        = bool
  default     = false
}

variable "test_pc_cidr" {
  description = "cidr"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "ssh key name"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "ssh public key"
  type        = string
  default     = ""
}

variable "param_cw_agent" {
  description = "Cloud Watch agent parameter name"
  type        = string
}

variable "cloudwatch_logs_group_name" {
  description = "CloudWatch Log group name"
  type        = string
  default     = "syslog"
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain logs for."
  type        = number
  default     = 14
}


variable "timezone" {
  default = "Asia/Seoul"
}
