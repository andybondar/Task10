data "google_compute_image" "debian" {
  project = "debian-cloud"
  family  = "debian-9"
}

# Creates a GCP VM Instance.
resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["http-server"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script = data.template_file.nginx.rendered
}

data "template_file" "nginx" {
  template = file("install_nginx.tpl")

  vars = {
    ufw_allow_nginx = "Nginx HTTP"
  }
}