variable "vinay_dg_password" {
  type        = string
  sensitive   = true
  description = "Password for Vinay, sourced from environment"
}

variable "vinay_password" {
  type        = string
  sensitive   = true
  description = "Password for Bob, sourced from environment"
}



module "user_creation" {
  source    = "./modules/openbao-users"
  namespace = module.bao_namespace.namespace_path

  user_data = {
    "vinay_dg" = { password = var.vinay_dg_password }
    "vinay"   = { password = var.vinay_password }
  }

  # 100% static structural mapping. OpenTofu can safely compute this at plan-time.
  user_memberships = {
    "vinay_dg" = ["admins"]
    "vinay"   = ["developers"]
  }

  # Dynamic resource IDs are funneled here as values.
  group_ids_lookup = {
    "admins"     = module.user_groups.group_ids.admin
    "developers" = module.user_groups.group_ids.developer
  }
}
