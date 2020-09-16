project       = "compact-retina-288017"
region        = "us-central1"
zone          = "us-central1-c"
machine_type  = "custom-1-4608"
disk_type     = "pd-ssd"
disk_size     = 30
images        = "centos-cloud/centos-7"

#network options 
student_name          = "dk"
external_http_ports   = ["80","443","8080"]
ssh_external_ports    = ["22"]
external_ranges       = ["0.0.0.0/0"]
datadog_tcp_ports     = ["17123","9012"]
datadog_udp_ports     = ["8125"]
internal_ranges       = ["10.2.0.0/24"]
public_subnet         = "10.2.1.0/24"
datadog_tags          = ["datadog-client"]

network_custom_vpc        = "dk-vpc"
subnetwork_custom_public  = "public-subnet"

api_url                   = "https://api.datadoghq.eu/"


