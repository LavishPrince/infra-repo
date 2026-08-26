output "read_role_ids" {
  value       = { for k, v in vault_approle_auth_backend_role.read_role : k => v.role_id }
  description = "Mapping of project name to its Read-Only AppRole Role ID within the namespace"
}
