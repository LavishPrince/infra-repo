variable "mount_path" {
  type        = string
  description = "Name/path of the KV mount inside the namespace"
  default     = "secret"
}

variable "project_branches" {
  type        = map(list(string))
  description = "Map of project names to their active branches"
}
