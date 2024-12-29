variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "The AWS profile to deploy the resources"
  type        = string
  default     = "default"
}
