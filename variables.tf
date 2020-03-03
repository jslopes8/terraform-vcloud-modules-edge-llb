variable "create" {
    type    = bool
    default = true
}
variable "name" {
    type    = string
}
variable "edge_gateway" {
    type    = string
}
variable "ip_address" {
    type    = string
}
variable "protocol" {
    type    = string
}
variable "port" {
    type    = string
}
variable "health_check" {
    type    = list(map(string))
    default = []
}
variable "algorithm" {
    type    = string
}
variable "algorithm_parameters" {
    type    = string
    default = ""
}
variable "enable_transparency" {
    type    = string
}
variable "member" {
    type    = list(map(string))
    default = []
}
variable "profile" {
    type    = list(map(string))
    default = []
}





