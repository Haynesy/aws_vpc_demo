# VPC configuyration
variable "environment" {  } # default = "demonstration_aws"
variable "aws_region" {  } # default = "ap-southeast-1"

# Lambda configuration
variable "lambda_zip_filename" {  } # default = "lambda.zip"
variable "lambda_zip_bucket" {  } # default = "demolambdas"

# Network configuration
variable "vpc_range" { default = "192.123.0.0/16" }
variable "public_subnet_range" { default = "192.123.0.0/24" }
variable "private_subnet_range" { default = "192.123.1.0/24" }
variable "availablitiy_zone" {default = "ap-southeast-1a"} # Additionally there is zone ap-southeast-1b

