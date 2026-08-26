# Admin Policy & Group
resource "vault_policy" "admin" {
  namespace = var.namespace
  name      = "admin-policy"
  policy    = <<EOT
path "*" {
    
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/*" {
    
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}

resource "vault_identity_group" "admin" {


  namespace = var.namespace
  name      = "admin-group"
  type      = "internal"
  policies  = [vault_policy.admin.name]
}

# Developer Policy & Group
resource "vault_policy" "developer" {
  namespace = var.namespace
  name      = "developer-policy"
  policy    = <<EOT
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "secret/metadata/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_identity_group" "developer" {
  namespace = var.namespace
  name      = "developer-group"
  type      = "internal"
  policies  = [vault_policy.developer.name]
}

# Reader Policy & Group
resource "vault_policy" "reader" {
  namespace = var.namespace
  name      = "reader-policy"
  policy    = <<EOT
path "secret/data/*" {
  capabilities = ["read", "list"]
}
path "secret/metadata/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_identity_group" "reader" {
  namespace = var.namespace
  name      = "reader-group"
  type      = "internal"
  policies  = [vault_policy.reader.name]
}
