# Creates the requested OpenBao namespace using the Vault provider
resource "vault_namespace" "this" {
  path = var.namespace_path
}
