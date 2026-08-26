output "auth_backend_path" {
  description = "The mount path of the JWT authentication engine."
  value       = vault_jwt_auth_backend.github.path
}
