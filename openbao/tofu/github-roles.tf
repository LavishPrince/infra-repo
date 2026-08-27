# 2. Global OIDC & Infra Management Engine Setup
module "github_core" {
  source              = "./modules/openbao-github-core"
  namespace_path      = var.namespace
  github_organization = "LavishPrince"
  management_repo     = "infra-repo"
}
