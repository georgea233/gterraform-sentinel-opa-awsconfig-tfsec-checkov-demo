package example

deny[msg] {
  input.resource_type == "aws_instance"
  input.config.instance_type != "t2.micro"
  msg = sprintf("EC2 instance '%s' must use instance_type 't2.micro'.", [input.config.name])
}

allow {
  not deny
}

