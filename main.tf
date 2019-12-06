# 対象のlambda
data "aws_lambda_function" "target" {
  function_name = var.target_lambda_name
}

# ロググループとlambdaのトリガー設定
## create_log_group = "true"の場合はこっち
### 対象のロググループを作成
resource "aws_cloudwatch_log_group" "target" {
  count             = "${var.create_log_group ? 1 : 0}"
  name              = var.log_group_name
  retention_in_days = var.log_group_retention
}

### lambdaのtrigger
resource "aws_lambda_permission" "create_target" {
  count         = "${var.create_log_group ? 1 : 0}"
  statement_id  = var.log_filter_name
  action        = "lambda:InvokeFunction"
  function_name = var.target_lambda_name
  principal     = "logs.ap-northeast-1.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.target[0].arn
}

### CloudwatchLogGroupのsubscription(どこに送信するか)
resource "aws_cloudwatch_log_subscription_filter" "create_target" {
  count           = "${var.create_log_group ? 1 : 0}"
  name            = var.log_filter_name
  log_group_name  = var.log_group_name
  filter_pattern  = var.lob_filter_word
  destination_arn = data.aws_lambda_function.target.arn
  depends_on      = [aws_cloudwatch_log_group.target]
}

## create_log_group = "false"の場合はこっち
### 対象のロググループをdataで取得
data "aws_cloudwatch_log_group" "target" {
  count = "${var.create_log_group ? 0 : 1}"
  name  = var.log_group_name
}

### lambdaのtrigger
resource "aws_lambda_permission" "data_target" {
  count         = "${var.create_log_group ? 0 : 1}"
  statement_id  = var.log_filter_name
  action        = "lambda:InvokeFunction"
  function_name = var.target_lambda_name
  principal     = "logs.ap-northeast-1.amazonaws.com"
  source_arn    = data.aws_cloudwatch_log_group.target[0].arn
}

### CloudwatchLogGroupのsubscription(どこに送信するか)
resource "aws_cloudwatch_log_subscription_filter" "data_target" {
  count           = "${var.create_log_group ? 0 : 1}"
  name            = var.log_filter_name
  log_group_name  = var.log_group_name
  filter_pattern  = var.lob_filter_word
  destination_arn = data.aws_lambda_function.target.arn
  depends_on      = [data.aws_cloudwatch_log_group.target]
}