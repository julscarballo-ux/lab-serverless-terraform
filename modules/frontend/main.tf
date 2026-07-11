# Generación automática de .env.production
resource "local_file" "env" {
  filename = "${path.root}/frontend/.env.production"
  content  = <<EOF
VITE_API_URL=${var.api_url}
VITE_USER_POOL_ID=${var.user_pool_id}
VITE_CLIENT_ID=${var.client_id}
VITE_REGION=${var.region}
VITE_API_KEY=${var.api_key}
EOF
}

# Build automático del frontend React
resource "null_resource" "react_build" {
  depends_on = [local_file.env]

  triggers = {
    env_content  = local_file.env.content
    package_json = filemd5("${path.root}/frontend/package.json")
  }

  provisioner "local-exec" {
    working_dir = "${path.root}/frontend"
    command     = "npm install && npm run build"
  }
}

# Sufijo único para nombres de recursos
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Bucket S3 para el frontend
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-frontend-${random_string.suffix.result}"

  tags = {
    Project     = var.project_name
    Environment = "lab"
    ManagedBy   = "Terraform"
    Owner       = "Cloud Team"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Versionamiento del bucket
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Website hosting
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Permitir acceso público
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política de lectura pública
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  depends_on = [
    aws_s3_bucket_public_access_block.frontend
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.frontend.arn}/*"
        ]
      }
    ]
  })
}

# Publicar index.html
resource "aws_s3_object" "index" {
  depends_on = [
    null_resource.react_build
  ]

  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  source       = "${path.root}/frontend/dist/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.root}/frontend/dist/index.html")
}

# Publicar assets React
resource "aws_s3_object" "assets" {
  for_each = fileset(
    "${path.root}/frontend/dist/assets",
    "**"
  )

  depends_on = [
    null_resource.react_build
  ]

  bucket = aws_s3_bucket.frontend.id
  key    = "assets/${each.value}"
  source = "${path.root}/frontend/dist/assets/${each.value}"
  etag = filemd5(
    "${path.root}/frontend/dist/assets/${each.value}"
  )

  content_type = lookup(
    {
      "js"  = "application/javascript"
      "css" = "text/css"
      "svg" = "image/svg+xml"
      "png" = "image/png"
      "jpg" = "image/jpeg"
      "ico" = "image/x-icon"
      "woff" = "font/woff"
      "woff2" = "font/woff2"
    },
    reverse(split(".", each.value))[0],
    "application/octet-stream"
  )
}

# Distribución CloudFront
resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket_website_configuration.frontend.website_endpoint
    origin_id   = "frontend-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD"
    ]
    target_origin_id       = "frontend-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # SPA: rutas no encontradas → index.html
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project     = var.project_name
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

# Invalidación automática de caché CloudFront (Parte 7)
resource "null_resource" "cloudfront_invalidation" {
  depends_on = [
    aws_s3_object.index,
    aws_s3_object.assets,
    aws_cloudfront_distribution.frontend
  ]

  triggers = {
    index_etag = aws_s3_object.index.etag
    assets_hash = sha1(jsonencode({
      for k, v in aws_s3_object.assets : k => v.etag
    }))
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.frontend.id} --paths '/*'"
  }
}
