#!/bin/bash

# Generate Terraform plan
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > terraform/plan.json

# Run OPA evaluation
opa eval --format pretty --data terraform/policies/example.rego \
--input terraform/plan.json "data.example.allow"

# Check OPA result and exit accordingly
if [ $? -ne 0 ]; then
  echo "OPA policy check failed. Fix violations before committing."
  exit 1
fi
