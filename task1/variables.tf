variable "project" {}

variable "region" {}

variable "zone" {}

variable "machine_type" {}

variable "disk_size" {}

variable "disk_type" {}

variable "images" {}

variable "student_name" {}

variable "external_ranges" {
	type = list
}

variable "external_http_ports" {
	type = list 
}

variable "ssh_external_ports" {
	type = list 
}

variable "datadog_tcp_ports" {
	type = list
}

variable "internal_ranges" {
	type = list
}

variable "datadog_udp_ports" {
	type = list
}

variable "public_subnet" {}

variable "subnetwork_custom_public" {}


variable "network_custom_vpc" {}

variable "datadog_tags" {
	type = list
}

variable "api_key" {}

variable "app_key" {}

variable "api_url" {}