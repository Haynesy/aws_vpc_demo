provider "aws" {
  region      = "${var.aws_region}"
  max_retries = 21 # Becuase sometime it fails ... alot
}