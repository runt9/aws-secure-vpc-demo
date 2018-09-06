variable "all_traffic_cidr" { default = "0.0.0.0/0" }

variable "application_vpc_cidr" { default = "10.0.0.0/16" }
variable "application_public_1_subnet" { default = "10.0.0.0/24" }
variable "application_public_2_subnet" { default = "10.0.10.0/24" }
variable "application_private_subnet" { default = "10.0.100.0/24" }

variable "database_vpc_cidr" { default = "10.10.0.0/16" }
variable "database_subnet" { default = "10.10.0.0/24" }

variable "management_vpc_cidr" { default = "10.20.0.0/16" }
variable "management_subnet" { default = "10.20.0.0/24" }