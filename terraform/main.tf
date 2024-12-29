resource "aws_s3_bucket" "example" {
  bucket = "example-terraform-sentinel"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
