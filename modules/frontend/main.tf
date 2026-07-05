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

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
