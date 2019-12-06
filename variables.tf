variable "create_log_group" {
  description = "Cloudwatch Log Groupを作成するか"
  default     = "true"
}

variable "log_filter_name" {
  description = "logfilter name"
}

variable "log_group_name" {
  description = "Cloudwatch Logs Group Name"
}

variable "lob_filter_word" {
  description = "特定のwordのみ送るとしたい場合のフィルター"
}

variable "log_group_retention" {
  description = "retention in days"
  default     = "30"
}

variable "target_lambda_name" {
  description = "add permission target lambda"
}