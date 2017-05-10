# Create a VPC to put it in
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.app_name}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.app_name}"
  }
}

# Create a subnet in the vpc
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.app_name}"
  }
}

# Add the elastic beanstalk app
resource "aws_elastic_beanstalk_application" "main" {
  name        = "${var.app_name}"
  description = "An example beanstalk app in ${var.language}"
}

# Create an environment on that app
resource "aws_elastic_beanstalk_environment" "main" {
  name                = "develop"
  application         = "${aws_elastic_beanstalk_application.main.name}"
  solution_stack_name = "${lookup(var.stacks, var.language)}"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.main.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.main.id}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "${var.port}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "${var.port}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MSG"
    value     = "${var.message}"
  }
}

# Create the bucket where revisions will be placed
resource "aws_s3_bucket" "main" {
  bucket = "tf_getting_started_${var.app_name}_release_bucket"

  tags {
    Name = "tf_getting_started_${var.app_name}_release_bucket"
  }
}

# Upload bundle to S3
resource "aws_s3_bucket_object" "main" {
  bucket = "${aws_s3_bucket.main.bucket}"
  key    = "${var.version}.zip"
  source = "${var.bundle}"
  etag   = "${md5(file(var.bundle))}"
}

# Create application version
resource "aws_elastic_beanstalk_application_version" "main" {
  name        = "${var.version}"
  application = "${aws_elastic_beanstalk_application.main.name}"
  description = "${var.app_name} ${var.version}"
  bucket      = "${aws_s3_bucket.main.id}"
  key         = "${aws_s3_bucket_object.main.id}"
}
