variable "namespace" {
  type        = string
  description = "The target OpenBao namespace"
}

variable "user_data" {
  type = map(object({
    password = string
  }))
  description = "Contains usernames and passwords. Keep this static."
}

variable "user_memberships" {
  type        = map(list(string))
  description = "A static map of Username -> Group Logical Keys (e.g., ['admin', 'dev'])"
}

# A map passed from your root module containing the actual live group IDs
variable "group_ids_lookup" {
  type        = map(string)
  description = "Map of Group Logical Keys to actual Vault Group IDs (e.g., { admin = 'uuid-1', dev = 'uuid-2' })"
}
