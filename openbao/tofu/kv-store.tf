module "project_kv_store" {
  source = "./modules/openbao-kv-store"

  mount_path     = "project-secrets"

  project_branches = {
    web-app     = ["main", "staging", "dev"]
    api-service = ["main", "dev"]
  }
}
