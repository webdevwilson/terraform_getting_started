variable "availability_zones" {
  type = "list"
}

variable "name" {}

variable "private_cidrs" {
  type = "list"
}

variable "public_cidrs" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "vpc_cidr" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.9.1"

  name = "${var.name}"
  cidr = "${var.vpc_cidr}"

  azs             = ["${var.availability_zones}"]
  private_subnets = ["${var.private_cidrs}"]
  public_subnets  = ["${var.public_cidrs}"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = "${var.tags}"
}

resource "aws_security_group" "public" {
  vpc_id = "${module.vpc.vpc_id}"
  description = "${var.name} Public"
  name_prefix = "${var.name}-pub-"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  vpc_id = "${module.vpc.vpc_id}"
  description = "${var.name} Private"
  name_prefix = "${var.name}-pri-"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = ["${aws_security_group.public.id}"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = ["${aws_security_group.public.id}"]
  }
  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "private_security_group_id" {
  value = "${aws_security_group.private.id}"
}

output "public_security_group_id" {
  value = "${aws_security_group.public.id}"
}
