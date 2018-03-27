# Create a security group for the lambda
resource "aws_security_group" "lambda" {
    name = "${var.environment}-lambda"
    description = "Controls lambda traffic out."
    vpc_id  = "${aws_vpc.main.id}"
    depends_on = ["aws_vpc.main"]
    tags {
        Name  = "${var.environment}-lambda"
        Environment = "${var.environment}"
    }
}

// Allow external calls using HTTPS
resource "aws_security_group_rule" "lambda_out_https" {
    security_group_id = "${aws_security_group.lambda.id}"
    type = "egress"
    from_port = 443
    to_port = 443
    protocol  = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
}

// Allow external calls using HTTP
resource "aws_security_group_rule" "lambda_out_http" {
    security_group_id = "${aws_security_group.lambda.id}"
    type = "egress"
    from_port = 80
    to_port = 80
    protocol  = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
}

# A role allows the lambda permission to be a lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// Base Policy with permissions for a lambda role
resource "aws_iam_role_policy" "iam_role_policy_for_lambda" {
  name = "${format("lambda_policy_%s", "test_lambda-${var.environment}")}"
  role = "${aws_iam_role.iam_for_lambda.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

// Create the actual lambda
resource "aws_lambda_function" "test_lambda" {
  s3_key            = "${var.lambda_zip_filename}"
  s3_bucket         = "${var.lambda_zip_bucket}"
  function_name     = "test_lambda-${var.environment}"
  role              = "${aws_iam_role.iam_for_lambda.arn}"
  handler           = "src.handler"
  runtime           = "nodejs6.10"
  timeout           = 30
  source_code_hash  = "${base64sha256(file("${var.lambda_zip_filename}"))}"

  vpc_config = {
    subnet_ids = ["${aws_subnet.private_subnet.id}"]
    security_group_ids=["${aws_security_group.lambda.id}"]
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}

