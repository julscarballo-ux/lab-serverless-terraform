output "api_url" {
  value = module.apigateway.api_url
}

output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "app_client_id" {
  value = module.cognito.client_id
}

output "region" {
  value = var.aws_region
}

output "api_key" {
  value     = module.apigateway.api_key
  sensitive = true
}

output "dynamodb_table" {
  value = "Files"
}

output "frontend_url" {
  value = module.frontend.frontend_url
}

output "bucket_name" {
  value = module.frontend.bucket_name
}

output "cloudfront_domain" {
  value = module.frontend.cloudfront_domain
}

output "env_file" {
  value = module.frontend.env_file
}

output "deployment_information" {
  value = {
    frontend   = module.frontend.frontend_url
    bucket     = module.frontend.bucket_name
    cloudfront = module.frontend.cloudfront_domain
  }
}
