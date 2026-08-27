# 1. Enable the Transit Secrets Engine (if not already enabled)
resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit secrets engine for OpenTofu state client-side encryption"
}

# 2. Create the encryption key for your state files
resource "vault_transit_secret_backend_key" "tofu_state_key" {
  backend          = vault_mount.transit.path
  name             = "tofu-state-key"
  type             = "aes256-gcm96" # Recommended GCM type for OpenTofu state
  deletion_allowed = false          # Safeguard to prevent accidental key deletion
}

# 3. Create a restrictive access policy for OpenTofu workers
resource "vault_policy" "tofu_encryption_policy" {
  name      = "opentofu-state-encryption"

  policy = <<EOT
# Allow OpenTofu to encrypt and decrypt its state payload
path "${vault_mount.transit.path}/datakey/plaintext/${vault_transit_secret_backend_key.tofu_state_key.name}" {
  capabilities = ["update"]
}

path "${vault_mount.transit.path}/encrypt/${vault_transit_secret_backend_key.tofu_state_key.name}" {
  capabilities = ["update"]
}
path "${vault_mount.transit.path}/decrypt/${vault_transit_secret_backend_key.tofu_state_key.name}" {
  capabilities = ["update"]
}

# Allow OpenTofu to read key metadata for verifying the cipher
path "${vault_mount.transit.path}/keys/${vault_transit_secret_backend_key.tofu_state_key.name}" {
  capabilities = ["read"]
}
EOT
}
