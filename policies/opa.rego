package terraform.plan

deny[msg] {
  input.resource_changes[_].type == "aws_instance"
  input.resource_changes[_].change.after.instance_type != "t2.medium"
  msg = "EC2 instances must use t2.medium instance type."
}
