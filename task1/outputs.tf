output "datadog-client" {
  value = "${google_compute_instance.datadog_client.network_interface.0.access_config.0.nat_ip}"
}

output "tomcat" {
  value = "http://${google_compute_instance.datadog_client.network_interface.0.access_config.0.nat_ip}:8080/sample"
}