variable "vpc_cidr" {
  type = string
}
variable "owner" {
  type = string
}

variable "name" {
  type = string
}
variable "organization" {
  type = string
}
variable "tfe_tags" {
  type = list
}

variable "branch" {
  type = string
}

variable "env" {
  type = string
}