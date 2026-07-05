output "create_file_name" {
  value = aws_lambda_function.create_file.function_name
}

output "get_files_name" {
  value = aws_lambda_function.get_files.function_name
}

output "get_file_by_id_name" {
  value = aws_lambda_function.get_file_by_id.function_name
}

output "update_file_name" {
  value = aws_lambda_function.update_file.function_name
}

output "delete_file_name" {
  value = aws_lambda_function.delete_file.function_name
}

output "create_file_invoke_arn" {
  value = aws_lambda_function.create_file.invoke_arn
}

output "get_files_invoke_arn" {
  value = aws_lambda_function.get_files.invoke_arn
}

output "get_file_by_id_invoke_arn" {
  value = aws_lambda_function.get_file_by_id.invoke_arn
}

output "update_file_invoke_arn" {
  value = aws_lambda_function.update_file.invoke_arn
}

output "delete_file_invoke_arn" {
  value = aws_lambda_function.delete_file.invoke_arn
}