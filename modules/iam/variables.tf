variable "sqs_queue_arn" {
  description = "ARN de la cola SQS para los permisos de la Lambda productora"
  type        = string
  default     = ""
}

variable "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB para los permisos de la Lambda consumidora"
  type        = string
  default     = ""
}