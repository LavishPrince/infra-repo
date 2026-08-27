module "user_groups" {
  source    = "./modules/openbao-groups"
  namespace = var.namespace
}
