#Set Up AWS Config: AWS Config provides a detailed inventory of your AWS resources, tracks their configuration history, and enables security and compliance checks.

provider "aws" {
  region = "us-east-2"
}

resource "aws_config_configuration_recorder" "main" {
  name     = "config-recorder"
  role_arn = aws_iam_role.config_role.arn
}

resource "aws_config_delivery_channel" "main" {
  name           = "config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-bucket"
}

resource "aws_iam_role" "config_role" {
  name = "AWSConfigRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}


# Enable AWS Config Rules: Use AWS Config rules to monitor public-facing assets, such as EC2 instances with public IPs or publicly accessible S3 buckets
resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "s3-bucket-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

# Rule to detects resources with public IP addresses and exposed APIs. This rule will help you to identify resources that are publicly accessible and might be vulnerable to attacks and data breaches and alert you if any EC2 violates this rule.
resource "aws_config_config_rule" "ec2_instance_no_public_ip" {
  name = "ec2-instance-no-public-ip"

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
  }
}

# Rule to detect publicly accessible API Gateway REST APIs. This rule will help you to identify API Gateway REST APIs that are publicly accessible and might be vulnerable to attacks and data breaches and alert you if any API Gateway REST API violates this rule. This one uses a custom rule that you can define using a Lambda function.
resource "aws_config_custom_rule" "api_exposed" {
  name        = "api-exposed-rule"
  lambda_function_arn = aws_lambda_function.api_check.arn
  input_parameters = jsonencode({
    "apiStatus" = "public"
  })
  maximum_execution_frequency = "TwentyFour_Hours"
}

resource "aws_lambda_function" "api_check" {
  filename         = "api_check.zip"
  function_name    = "api-check"
  handler          = "index.handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("./api_check_script/api_check.zip") # Use filebase64sha256 to hash the zip file. 
}


# Set Up AWS Config Notifications: Set up AWS Config notifications to receive alerts when a resource violates a rule. You can send notifications to an SNS topic, which can then send an email notification to your email address.
resource "aws_sns_topic" "config_alerts" {
  name = "config-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.config_alerts.arn
  protocol  = "email"
  endpoint  = "gakanza@gmail.com"
}

resource "aws_config_config_rule" "ec2_instance_no_public_ip" {
  name = "ec2-instance-no-public-ip"

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
  }

#   notification_rule {
#     target_arn = aws_sns_topic.config_alerts.arn
#   }
}
