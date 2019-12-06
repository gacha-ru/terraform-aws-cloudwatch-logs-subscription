# Datadog cloudwatch logs subscription

## OverView
Cloudwatch LogsのsubscriptionとLambdaのtrigger許可を作成する  

## Create

### aws
- aws_iam_policy_document.datadog_logs_lambda_policy_doc
- aws_iam_role.datadog_logs_lambda_role
- aws_iam_role_policy.datadog_logs_lambda_policy
- aws_lambda_function.datadog_logs


## Usage

```
# Cloudwatch Log Groupを作成する
module "logs_subscription" {
  source              = "git@github.com:gacha-ru/terraform-aws-cloudwatch-logs-subscription.git"
  log_group_name      = "/aws/rds/cluster/hoge-prd-master-db/slowquery"
  lob_filter_word     = ""
  log_group_retention = 14
  target_lambda_name  = "datadog_logs"
}

# Cloudwatch Log Groupを作成しない。
# この場合、log_filter_nameのロググループが事前に作成されていないとエラーになります。
module "logs_subscription" {
  source              = "git@github.com:gacha-ru/terraform-aws-cloudwatch-logs-subscription.git"
  create_log_group    = "false"
  log_filter_name     = "${aws_rds_cluster.hoge.cluster_identifier}-slowquery"
  log_group_name      = "/aws/rds/cluster/${aws_rds_cluster.hoge.cluster_identifier}/slowquery"
  lob_filter_word     = ""
  log_group_retention = 14
  target_lambda_name  = "datadog_logs"
}
```

## Inputs
|Name|Description|type|Default|required|
|:--|:--|:--|:--|:--|
|create_log_group|ロググループを作成=true,すでに作成されているgroupを参照=false|bool|true|×|
|log_filter_name|lambdaのtriggerに表示されるフィルターの名前|string|none|○|
|log_group_name|CloudWatch Logsのロググループ名|string|none|○|
|lob_filter_word|特定の文字列のみ対象とする場合のフィルターワード|string|none|○|
|log_group_retention|何日でログ削除するか|number|30|×|
|target_lambda_name|ログを転送する先のlambda|string|none|○|

## Outputs
none