#SFTP Variables
variable "aws-transfer-server-name" {
    default = ""
    type = string
}
variable "application" {
    default = ""
    type = string
}

variable "service" {
    default = ""
    type = string
}

variable "environment" {
    default = ""
    type = string
}

variable "role" {
    default = ""
    type = string
}

variable "policy" {
    default = ""
    type = string
}

# variable "user_group_name" {
#     description = "A map of key and user"
#     type = map(object({
#         keys= list(string)
#     }))
# }

variable "user_group_name" {
    description = "A map of key and user"
    type = map(object({
        username   = string
        home_dir   = string
  }))
}

variable "endpoint_details" {
  type = object({
    subnet_ids = list(string)
    vpc_id     = string
    security_group_ids = list(string)
  })
  description = "endpoint details"
}