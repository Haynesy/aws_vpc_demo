# VPC configuyration
variable "environment" { default = "demonstration_aws" }
variable "aws_region" { default = "ap-southeast-1" }

# Network configuration
variable "vpc_range" { default = "192.123.0.0/16" }
variable "subnet_range" { default = "192.123.0.0/24" }
variable "availablitiy_zone" {default = "ap-southeast-1a"} # Additionally there is zone ap-southeast-1b

# Lambda configuration
variable "lambda_function_name" { default = "test_lambda" }
variable "lambda_zip_filename" { default = "lambda.zip" }
variable "lambda_zip_bucket" { default = "demolambdas" }

