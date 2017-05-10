# modules are used to create usable terraform manifests
module "my_module" {
  source  = "../03_manifest_variable"
  message = "hello from parent module"
}
