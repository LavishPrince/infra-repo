# 1. Enable Userpass Auth Method
resource "vault_auth_backend" "userpass" {
  namespace   = var.namespace
  type        = "userpass"
  path        = "userpass"
  description = "Userpass auth backend inside custom namespace"
}

# 2. Dynamically create Identity Entities for all users
resource "vault_identity_entity" "users" {
  namespace = var.namespace
  for_each  = var.user_data
  name     = each.key
  policies = ["default"]
}

# 3. Create Userpass Credentials for all users
resource "vault_generic_endpoint" "userpass_users" {
  namespace  = var.namespace
  for_each   = var.user_data
  depends_on           = [vault_auth_backend.userpass]
path                 = "auth/userpass/users/${each.key}"
ignore_absent_fields = true
data_json = jsonencode({
  password = each.value.password   })
}

# 4. Link each Userpass Login to its corresponding Identity Entity
resource "vault_identity_entity_alias" "user_aliases" {
  namespace = var.namespace
  for_each  = var.user_data
  name           = each.key
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.users[each.key].id
}

# 5. Process purely static keys for memberships
locals {
  # Build a flat mapping of structural keys (strings only!)
  static_flat = flatten([     for username, group_keys in var.user_memberships : [       for group_key in group_keys : {         group_key = group_key
    username  = username       }     ]   ])

# Group usernames by their structural group keys
group_to_usernames = {
for item in local.static_flat : item.group_key => item.username...   }
}

# 6. Assign Users to Groups safely
resource "vault_identity_group_member_entity_ids" "membership" {
  namespace = var.namespace
  for_each  = local.group_to_usernames # 100% static structural keys, OpenTofu knows these!
  # Resolve the dynamic Group UUID using our lookup variable during apply
  group_id  = var.group_ids_lookup[each.key]
  exclusive = false

  # Resolve the dynamic User UUIDs during apply
  member_entity_ids = [     for username in each.value : vault_identity_entity.users[username].id   ]
}
