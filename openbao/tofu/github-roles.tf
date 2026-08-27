# 2. Global OIDC & Infra Management Engine Setup
module "github_core" {
  source              = "./modules/openbao-github-core"
  github_organization = "LavishPrince"
  management_repo     = "infra-repo"
}
