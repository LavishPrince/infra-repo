# 1. Mount KV V2 inside the passed namespace
resource "vault_mount" "kv" {
  namespace   = var.namespace_path
  path        = var.mount_path
  type        = "kv"
  options     = { version = "2" }
  description = "KV v2 store for projects and branches"
}

# 2. Extract unique project names
locals {
  project_branch_pairs = flatten([
    for project, branches in var.project_branches : [
      for branch in branches : {
        project = project
        branch  = branch
        path    = "${project}/${branch}/config"
      }
    ]
  ])

  projects = keys(var.project_branches)
}

# 3. Create Placeholder Secrets inside the passed namespace
resource "vault_kv_secret_v2" "branch_placeholder" {
  for_each  = { for item in local.project_branch_pairs : item.path => item }

  namespace = var.namespace_path
  mount     = vault_mount.kv.path
  name      = each.value.path
  data_json = jsonencode({
    initialized = true
    project     = each.value.project
    branch      = each.value.branch
  })
}

# 4. Enable AppRole Auth Backend inside the passed namespace
resource "vault_auth_backend" "approle" {
  namespace = var.namespace_path
  type      = "approle"
  path      = "approle"
}

# 5. Project CRUD Policies inside the passed namespace
resource "vault_policy" "project_crud" {
  for_each  = toset(local.projects)
  namespace = var.namespace_path
  name      = "${each.key}-crud"

  policy = <<EOT
# Read, Write, Delete secrets under the project path
path "${var.mount_path}/data/${each.key}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
# Metadata control for KV v2 deletions/versions
path "${var.mount_path}/metadata/${each.key}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

# 6. Project Read-Only Policies inside the passed namespace
resource "vault_policy" "project_read" {
  for_each  = toset(local.projects)
  namespace = var.namespace_path
  name      = "${each.key}-read"

  policy = <<EOT
# Read-only access to secrets under the project path
path "${var.mount_path}/data/${each.key}/*" {
  capabilities = ["read", "list"]
}
path "${var.mount_path}/metadata/${each.key}/*" {
  capabilities = ["read", "list"]
}
EOT
}

# 7. Bind Read-Only AppRoles inside the passed namespace
resource "vault_approle_auth_backend_role" "read_role" {
  for_each       = toset(local.projects)
  namespace      = var.namespace_path
  backend        = vault_auth_backend.approle.path
  role_name      = "${each.key}-read-role"
  token_policies = [vault_policy.project_read[each.key].name]
}
