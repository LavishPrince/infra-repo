module "user_groups" {
  source    = "./modules/openbao-groups"
  namespace = module.bao_namespace.namespace_path
}