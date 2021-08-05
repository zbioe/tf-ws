resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.ws.id

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "webserver" {
  name    = "allow-webserver"
  network = google_compute_network.ws.id

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }

  target_tags = ["webserver"]
}
