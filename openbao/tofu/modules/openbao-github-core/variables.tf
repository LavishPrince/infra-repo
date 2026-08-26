variable "namespace_path" {
  type        = string
  description = "The target namespace where this auth backend should live."
}

variable "github_organization" {
  type        = string
  description = "The GitHub Organization or Username owning the repositories."
}

variable "management_repo" {
  type        = string
  description = "The repository name managing OpenBao infra via OpenTofu."
}
