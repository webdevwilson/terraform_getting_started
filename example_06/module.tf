# modules are used to create usable terraform manifests
# can be local directories or vcs repositories that contain .tf files
# you can set pass variables to a module and retrieve the outputs
module my_module {
  source  = "./child"
  message = "hello from parent module"
}

output child_message {
  value = module.my_module.out
}
