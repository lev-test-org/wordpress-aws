variable "tags" {
  type = map(string)
}
variable "name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "active_dns" {
  type = string
  default = null
}