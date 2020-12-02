variable "container_mem_limit" {
  default     = 5120
  description = "limit container memory (MB)"
  type        = number
}


variable "docker_networks" {
  default     = []
  description = "list of docker networks to connect the container to"
  type        = list(string)
}

variable "env_vars" {
  default     = []
  description = "additional env vars for the container"
  type        = list(string)
}

variable "group_list" {
  default = [
    999,  # add docker group (please change on the host as well!)
    1000, # add first non-system user by default
  ]
  description = "list of system groups (ids) to add to the container"
  type        = list(number)
}

variable "upload_files" {
  default     = {}
  description = "additional config data to upload to the container upon creation, with key being the container path and value the uploaded file data"
  type        = map(string)
}
