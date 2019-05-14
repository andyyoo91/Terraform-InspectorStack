provider "aws" {
  #   access_key = ""
  #   secret_key = ""
  region = "us-east-1"
}

resource "aws_vpc" "andy_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags {
    Name = "AndyVPC"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id     = "${aws_vpc.andy_vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"

  tags = {
    Name = "Andy_Private_Subnet"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id     = "${aws_vpc.andy_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"

  tags {
    Name = "Andy_Public_Subnet"
  }
}

resource "aws_instance" "AY_EC2_1" {
  ami           = "ami-0080e4c5bc078760e"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.Private_Subnet.id}"

  tags {
    Name = "Andy_Private_EC2"
  }
}

resource "aws_instance" "AY_EC2_2" {
  ami           = "ami-0080e4c5bc078760e"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.Public_Subnet.id}"

  tags {
    Name = "Andy_Public_EC2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.andy_vpc.id}"

  tags = {
    Name = "Andy_IGW"
  }
}

resource "aws_inspector_resource_group" "Yoo" {
  tags = {
    Name = "Andy_Private_EC2"
    Name = "Andy_Public_EC2"
  }
}

resource "aws_inspector_assessment_target" "Inspector" {
  name = "my-assessment target"
}

resource "aws_inspector_assessment_template" "Inspector" {
  name       = "bar template"
  target_arn = "${aws_inspector_assessment_target.Inspector.arn}"
  duration   = 4500

  rules_package_arns = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-PmNV0Tcd",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
  ]
}

resource "aws_cloudwatch_event_target" "inspector" {
  target_id = "Andy_inspector"
  rule      = "${aws_cloudwatch_event_rule.inspector.name}"
  arn       = "${aws_inspector_assessment_template.Inspector.arn}"
  role_arn  = "${aws_iam_role.run_inspector_role.arn}"
}

resource "aws_cloudwatch_event_rule" "inspector" {
  name                = "run-inspector-event-rule"
  description         = "AWS Inspector run for based on CloudWatch Event trigger"
  schedule_expression = "rate(7 days)"
}
