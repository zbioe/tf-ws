locals {
  api_services = [
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
  pub_ip = google_compute_instance.ws.network_interface.0.access_config.0.nat_ip
  priv_ip = google_compute_instance.ws.network_interface.0.network_ip
}

resource "google_project_service" "enabled" {
  for_each           = toset(local.api_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "ws" {
  name                    = "ws-net"
  auto_create_subnetworks = "true"
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "google_service_account" "ws" {
  account_id   = "webserver-${random_id.suffix.hex}"
  display_name = "Web Server Account"
}

resource "google_project_iam_member" "ws" {
  project = var.project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.ws.email}"
}

resource "google_service_account_key" "ws" {
  service_account_id = google_service_account.ws.id
}

resource "google_storage_bucket" "ws-data" {
  name = "ws-data-${random_id.suffix.hex}"
  force_destroy = true
}

resource "google_compute_instance" "ws" {
  name         = "ws"
  machine_type = "f1-micro"
  tags         = ["nginx", "webserver", "terraform", "ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.ws.self_link
    access_config {}
  }

  metadata_startup_script = <<EOF
  #!/bin/bash

  set -euo pipefail
  
  echo '${google_service_account_key.ws.private_key}' > /etc/gcp-auth.json.b64
  base64 -d /etc/gcp-auth.json.b64 > /etc/gcp-auth.json
  
  echo '${file("files/setup.sh")}' > /run/setup.sh
  bash /run/setup.sh
  
  mkdir -p /data
  bucket='${google_storage_bucket.ws-data.name}'
  raw="$bucket /data gcsfuse key_file=/etc/gcp-auth.json,rw,_netdev,allow_other,uid=1001,gid=1001,implicit_dirs"

  if ! grep -q "$bucket" /etc/fstab
  then
    echo "$raw" >> /etc/fstab
  fi
  
  mount -a
  mkdir -p /data/nginx
  
  sed -i s,'var/log','data',g /etc/nginx/nginx.conf
  systemctl restart nginx

  EOF

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

}



