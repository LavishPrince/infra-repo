module "project_kv_store" {
  source = "./modules/openbao-kv-store"

  namespace_path = module.bao_namespace.namespace_path
  mount_path     = "project-secrets"

  project_branches = {
    web-app     = ["main", "staging"]
    api-service = ["main", "dev"]
  }
}
