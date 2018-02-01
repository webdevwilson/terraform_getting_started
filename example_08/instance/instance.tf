variable "ami_id" {}

variable "name" {}

variable "instance_type" {}

variable "instance_min_size" {}

variable "instance_max_size" {}

variable "private_security_group_id" {}

variable "public_security_group_id" {}

variable "private_subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "tags" {
  type = "map"
}

resource "aws_elb" "instance" {
  name_prefix = "${substr(var.name, 0, 5)}-"
  security_groups = ["${var.public_security_group_id}"]
  subnets     = ["${var.public_subnet_ids}"]
  tags        = "${var.tags}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

# Create launch configuration
resource "aws_launch_configuration" "instance" {
  name_prefix     = "${var.name}-"
  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${var.private_security_group_id}"]
  user_data       = "${file(join("/", list(path.module, "bootstrap.sh")))}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create autoscaling group
resource "aws_autoscaling_group" "instance" {
  name_prefix          = "${var.name}-"
  launch_configuration = "${aws_launch_configuration.instance.name}"
  load_balancers       = ["${aws_elb.instance.id}"]
  min_size             = "${var.instance_min_size}"
  max_size             = "${var.instance_max_size}"
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]

  tag {
    propagate_at_launch = true
    key                 = "Name"
    value               = "${lookup(var.tags, "Name")}"
  }

  tag {
    propagate_at_launch = true
    key                 = "Terraform"
    value               = "${lookup(var.tags, "Terraform")}"
  }


  lifecycle {
    create_before_destroy = true
  }
}

output "elb_dns_name" {
  value = "${aws_elb.instance.dns_name}"
}

output "elb_zone_id" {
  value = "${aws_elb.instance.zone_id}"
}