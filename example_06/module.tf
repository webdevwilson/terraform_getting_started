# modules are used to create usable terraform manifests
# can be local directories or repositories that contain .tf files
module "my_module" {
  source  = "./child"
  message = "hello from parent module"
}

output "child_message" {
  value = "${module.my_module.out}"
}
