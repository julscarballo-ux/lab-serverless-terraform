variable "lambda_role_arn" {
  type = string
}

variable "queue_url" {
  description = "URL de la cola SQS para la Lambda"
  type        = string
  default     = ""
}