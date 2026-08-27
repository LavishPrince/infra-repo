# Admin Policy & Group
resource "vault_policy" "admin" {
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
  name      = "admin-group"
  type      = "internal"
  policies  = [vault_policy.admin.name]
}

# Developer Policy & Group
resource "vault_policy" "developer" {
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
  name      = "developer-group"
  type      = "internal"
  policies  = [vault_policy.developer.name]
}

# Reader Policy & Group
resource "vault_policy" "reader" {
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
  name      = "reader-group"
  type      = "internal"
  policies  = [vault_policy.reader.name]
}
