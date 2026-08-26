variable "pwd_postgres_01" {
  type = string
  sensitive = true
}
variable "pwd_postgres_02" {
  type = string
  sensitive = true
}

module "db_billing_payments" {
  source          = "./modules/openbao-database-instance"
  namespace_path  = module.bao_namespace.namespace_path
  connection_name = "postgres_01"
  admin_username  = "postgres"

  host            = "postgres_01"
  database_name   = "postgres"
  schema_names    = ["public", "test_03", "test_04"] # Manual Schema Mapping
  admin_password  = var.pwd_postgres_01
  default_ttl     = 3600
}

module "db_billing_invoices" {
  source          = "./modules/openbao-database-instance"
  namespace_path  = module.bao_namespace.namespace_path
  connection_name = "postgres_02"
  admin_username  = "postgres"

  host            = "postgres_02"
  database_name   = "postgres"
  schema_names    = ["public", "test_01", "test_02"] # Manual Schema Mapping
  admin_password  = var.pwd_postgres_02
  default_ttl     = 1800
}
