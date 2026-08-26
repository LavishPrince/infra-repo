output "namespace_path" {
  description = "The verified path of the created namespace."
  value       = vault_namespace.this.path
}

output "namespace_id" {
  description = "The unique system ID assigned to the namespace."
  value       = vault_namespace.this.id
}
