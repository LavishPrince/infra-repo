# Enable JWT Authentication Backend for GitHub Actions OIDC (Once per namespace)
resource "vault_jwt_auth_backend" "github" {
  namespace = var.namespace_path
  path               = "github"
  type               = "jwt"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

# Policy allowing complete configuration management inside the namespace
resource "vault_policy" "tofu_management" {
  namespace = var.namespace_path
  name      = "opentofu-management"
  policy    = <<EOT
path "metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "transit/datakey/plaintext/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "auth/${vault_jwt_auth_backend.github.path}/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOT
}

# Map GitHub OIDC claims to the Management Policy
resource "vault_jwt_auth_backend_role" "tofu_management" {
  namespace = var.namespace_path
  backend        = vault_jwt_auth_backend.github.path
  role_name      = "opentofu-manager"
  token_policies = [vault_policy.tofu_management.name, "opentofu-state-encryption"]
  bound_audiences = ["https://github.com"]
  bound_claims_type = "glob"
  bound_claims = {
    repository = "${var.github_organization}/${var.management_repo}"
  }
  user_claim = "sub"
  role_type  = "jwt"
  token_ttl  = 1200
}
