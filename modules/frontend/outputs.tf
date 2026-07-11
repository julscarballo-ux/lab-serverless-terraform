output "frontend_url" {
  value = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "env_file" {
  value = local_file.env.filename
}

output "dist_path" {
  value = "${path.root}/frontend/dist"
}

output "suffix" {
  value = random_string.suffix.result
}
