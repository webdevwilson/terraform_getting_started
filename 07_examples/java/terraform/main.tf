variable "version" {
  default = "1.0-SNAPSHOT"
}

variable "bundle" {
  default = "../target/deploy.zip"
}

data "archive_file" "app" {
  type        = "zip"
  source_file = "../target/tf-java-${var.version}.jar"
  output_path = "${var.bundle}"
}

module "beanstalk" {
  source            = "../../beanstalk"
  language          = "java"
  app_name          = "tf_getting_started_java"
  bundle            = "${var.bundle}"
  bundle_sha256hash = "${data.archive_file.app.output_base64sha256}"
  version           = "${var.version}"
}

output "hostname" {
  value = "${module.beanstalk.aws_elastic_beanstalk_cname}"
}
