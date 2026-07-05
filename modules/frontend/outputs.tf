output "env_file" {
  value = local_file.env.filename
}

output "dist_path" {
  value = "${path.root}/frontend/dist"
}

output "suffix" {
  value = random_string.suffix.result
}

output "frontend_url" {
  value       = null
  description = "Se configurará en la Parte 6 con CloudFront"
}

output "bucket_name" {
  value       = null
  description = "Se configurará en la Parte 6 con S3"
}

output "cloudfront_domain" {
  value       = null
  description = "Se configurará en la Parte 6 con CloudFront"
}
