data "archive_file" "consumer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/backend/consumer"
  output_path = "${path.module}/backend/consumer.zip"
}

resource "aws_lambda_function" "consumer" {
  function_name = "documents-consumer"
  filename      = data.archive_file.consumer_zip.output_path
  source_code_hash = data.archive_file.consumer_zip.output_base64sha256
  role          = module.iam.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  environment {
    variables = {
      TABLE_NAME = module.dynamodb.table_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.documents_queue.arn
  function_name    = aws_lambda_function.consumer.arn
  batch_size       = 1
}
