variable "project_name" {
    default = {}
}

variable "environment" {
    default = {}
}

variable "vpc_cidr" {
    default = {}
}

variable "common_tags" {
    default = {}
}
variable "public_cidr" {
    type = list
    validation {
        condition = length(var.public_cidr) == 2
        error_message = "please Provide 2 valid public cidrs"
    }
}
variable "private_cidr" {
    type = list
    validation {
        condition = length(var.private_cidr) == 2
        error_message = "please Provide 2 valid private cidrs"
    }
}
variable "database_cidr" {
    type = list
    validation {
        condition = length(var.database_cidr) == 2
        error_message = "please Provide 2 valid database cidrs"
    }
}
variable "is_peering_required" {
    type =  bool    
}
variable "peer_owner_id" {
    default = {}
}