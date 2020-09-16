# create VPC
resource "google_compute_network" "vpc_network" {
  name                    = "${var.student_name}-vpc"
  auto_create_subnetworks = false
  description             = "custom-vpc-network"
}

# create public subnet
resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = var.public_subnet
  network       = google_compute_network.vpc_network.id
  description   = "public-subnet in ${var.student_name}-vpc"
  region        = var.region
}

# create firewall rules
resource "google_compute_firewall" "external-http-port" {
  name    = "${var.student_name}-fw-http-lb"
  network = google_compute_network.vpc_network.id
  allow {
    ports    = var.external_http_ports
	protocol = "tcp"
  }
  target_tags   = var.datadog_tags 
  description   = "rule for http/https ports"
}

resource "google_compute_firewall" "external-ssh-port" {
  name    = "${var.student_name}-fw-ssh"
  network = google_compute_network.vpc_network.id
  allow {
    ports    = var.ssh_external_ports
	protocol = "tcp"
  }
  target_tags   = var.datadog_tags 
  description   = "rule for ssh port"
}

resource "google_compute_firewall" "datadog-ports" {
  name    = "${var.student_name}-datadog-ports"
  network = google_compute_network.vpc_network.id
  allow {
    ports    = var.datadog_tcp_ports
	protocol = "tcp"
  }
  allow {
    ports    = var.datadog_udp_ports
	protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  target_tags   = var.datadog_tags 
  description   = "rule for datalog-client"
}


