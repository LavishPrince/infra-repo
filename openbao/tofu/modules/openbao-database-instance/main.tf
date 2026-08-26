# 1. Mount a dedicated database backend for this specific connection.
# Splitting mounts ensures complete engine-level isolation per database instance.
resource "vault_mount" "db" {
  namespace   = var.namespace_path
  path        = "database-${var.connection_name}"
  type        = "database"
  description = "Dynamic credentials engine for ${var.connection_name}"
}

# 2. Configure OpenBao's connection to this specific PostgreSQL targets
resource "vault_database_secret_backend_connection" "postgres" {
  namespace     = var.namespace_path
  backend       = vault_mount.db.path
  name          = "conn-${var.connection_name}"
  allowed_roles = flatten([
    for schema in var.schema_names : [
      "role-${var.connection_name}-${schema}",
      "role-${var.connection_name}-${schema}-read-only"
    ]
  ])


  postgresql {
    connection_url = "postgresql://${var.admin_username}:${var.admin_password}@${var.host}:${var.port}/${var.database_name}?sslmode=disable"
  }
}

# 3. Provision the matching dynamic credential role mapping your manual schema name
# 3a. Read-Write Roles for each schema
resource "vault_database_secret_backend_role" "webapp" {
  for_each = var.schema_names

  namespace   = var.namespace_path
  backend     = vault_mount.db.path
  name        = "role-${var.connection_name}-${each.value}"
  db_name     = vault_database_secret_backend_connection.postgres.name
  default_ttl = var.default_ttl
  max_ttl     = 86400 

  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${each.value} TO \"{{name}}\";"
  ]

  revocation_statements = [
    "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ${each.value} FROM \"{{name}}\";",
    "DROP ROLE IF EXISTS \"{{name}}\";"
  ]
}

# 3b. Read-Only Roles for each schema
resource "vault_database_secret_backend_role" "read_only" {
  for_each = var.schema_names

  namespace   = var.namespace_path
  backend     = vault_mount.db.path
  name        = "role-${var.connection_name}-${each.value}-read-only"
  db_name     = vault_database_secret_backend_connection.postgres.name
  default_ttl = var.default_ttl
  max_ttl     = 86400 

  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA ${each.value} TO \"{{name}}\";",
  ]

  revocation_statements = [
    "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ${each.value} FROM \"{{name}}\";",
    "DROP ROLE IF EXISTS \"{{name}}\";"
  ]
}
