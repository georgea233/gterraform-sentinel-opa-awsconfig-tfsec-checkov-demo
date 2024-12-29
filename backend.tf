terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "fluentindevops-tf-statefile"
    key    = "fluentindevops-tf-statefile/sentinel-opa/statefile"
    region = "us-east-2"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "fluentindevops-tf-state-lock"
  }
}
