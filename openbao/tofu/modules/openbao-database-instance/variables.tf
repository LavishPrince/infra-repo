variable "namespace_path" {
  type        = string
  description = "The target namespace where this database should live."
}

variable "connection_name" {
  type        = string
  description = "A unique tracking name for this OpenBao connection backend (e.g., 'billing-payments')."
}

variable "host" {
  type        = string
  description = "The target PostgreSQL instance server hostname or IP address."
}

variable "port" {
  type        = number
  default     = 5432
  description = "The port your PostgreSQL database is listening on."
}

variable "database_name" {
  type        = string
  description = "The specific database name to connect to on the host instance."
}

variable "schema_names" {
  type        = set(string)
  description = "List of database schemas to create roles for."
  default     = ["public", "analytics"]
}


variable "admin_username" {
  type        = string
  default     = "openbao_admin"
  description = "The admin username OpenBao uses to manage dynamic roles."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "The high-privilege password for the admin account, loaded via environment."
}

variable "default_ttl" {
  type        = number
  default     = 3600
  description = "The default duration (in seconds) that generated credentials remain valid."
}
