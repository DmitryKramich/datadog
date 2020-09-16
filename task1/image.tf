provider "google" {
  credentials = "terraform-admin.json"
  project     = var.project
  region      = var.region
}

# create instance datadog-client
resource "google_compute_instance" "datadog_client" {
  name            = "datadog_client"
  can_ip_forward  = true
  machine_type    = var.machine_type
  zone            = var.zone
  tags            = var.datadog_tags
  
  boot_disk {
    initialize_params {
	  size  = var.disk_size
	  type  = var.disk_type
	  image = var.images
    }
  }
  
  metadata_startup_script = templatefile("datadog-agent.sh", {
    key = "${var.api_key}" })
	
  depends_on = [google_compute_subnetwork.public]
  
  network_interface {
	network    = var.network_custom_vpc
    subnetwork = var.subnetwork_custom_public
    access_config {}
  }
}

# create simple custom alert-monitor for tomcat 
provider "datadog" {
  api_key = var.api_key
  app_key = var.app_key
  api_url = var.api_url
}

resource "datadog_monitor" "monitor" {
  name               = "stoped sample app"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: dmitrykramich@yandex.by"
  query              = "avg(last_5m):avg:network.http.can_connect{url:http://34.67.31.249:8080/sample/} < 1"
  depends_on         = [google_compute_instance.datadog_client]
}