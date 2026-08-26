output "group_ids" {
  value = {
    admin     = vault_identity_group.admin.id
    developer = vault_identity_group.developer.id
    reader    = vault_identity_group.reader.id
  }
}
