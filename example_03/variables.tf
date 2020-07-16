# variables are used to pass in configuration settings to terraform. Pass
# them in as environment variables or they can be read from terraform.tfvars
#
# Types:
#   - string - a sequence of Unicode characters representing some text, such as "hello".
#   - number - a numeric value. The number type can represent both whole numbers like 15 and fractional values such as 6.283185.
#   - bool - either true or false. bool values can be used in conditional logic.
#   - list(string)
#   - map(string)

# Run the following command to see the different ways to set a variable
# TF_VAR_from_env='Hello from environment!' terraform apply -var from_command='Hello from command!' -auto-approve && cat file

# You can set a default for a variable
variable from_default {
  type        = "string"
  description = "I will be put into a file"
  default     = "Hello from default!"
}

variable from_command {
  default = ""
}

variable from_env {
  default = ""
}

variable from_tfvars {
  default = ""
}

variable from_prompt {}

resource local_file foo {
  content  = "${var.from_default}\n${var.from_env}\n${var.from_tfvars}\n${var.from_command}\n${var.from_prompt}\n"
  filename = "file"
}
