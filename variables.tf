variable "name" {
  type = string

  default = "staticfile"
}

variable "namespace" {
  type = string

  default = null
}

variable "nginx_image" {
  type = string

  default = "nginx:latest"

  description = "Make sure to specify a docker image digest for production use"
}

variable "content" {
  type = string
}

variable "content_type" {
  type = string

  default = "text/html"
}
