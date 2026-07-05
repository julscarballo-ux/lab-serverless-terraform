module "dynamodb" {

  source = "./modules/dynamodb"

}

module "cognito" {

  source = "./modules/cognito"

}

module "iam" {

  source = "./modules/iam"

}

module "lambda" {
  source = "./modules/lambda"

  lambda_role_arn = module.iam.lambda_role_arn
}

module "apigateway" {
  source = "./modules/apigateway"

  create_file_arn    = module.lambda.create_file_invoke_arn
  get_files_arn      = module.lambda.get_files_invoke_arn
  get_file_by_id_arn = module.lambda.get_file_by_id_invoke_arn
  update_file_arn    = module.lambda.update_file_invoke_arn
  delete_file_arn    = module.lambda.delete_file_invoke_arn

  create_file_name    = module.lambda.create_file_name
  get_files_name      = module.lambda.get_files_name
  get_file_by_id_name = module.lambda.get_file_by_id_name
  update_file_name    = module.lambda.update_file_name
  delete_file_name    = module.lambda.delete_file_name

  cognito_user_pool_arn = module.cognito.user_pool_arn
}