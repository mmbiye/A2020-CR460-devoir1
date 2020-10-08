provider "google" {
  project = "monprojetd"
  credentials = "account.json"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
}

resource "google_compute_instance" "canard" {
  name         = "canard"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-dmz.name
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
}
resource "google_compute_instance" "mouton" {
  name         = "mouton"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "coreOs"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-interne.name
    access_config {
    }
  }

  }

resource "google_compute_instance" "cheval" {
  name         = "cheval"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "coreOs"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-traitement.name
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade"
}
resource "google_compute_instance" "fermier" {
  name         = "fermier"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "coreOs2004"
    }
  }

  network_interface {
    network = google_compute_network.default.name
    access_config {
    }

resource "google_compute_network" "devoir1" {
  name                    = "devoir1"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "prod-dmz" {
  name          = "prod-dmz"
  ip_cidr_range = "172.16.3.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.devoir1.self_link
}

resource "google_compute_subnetwork" "prod-interne" {
  name          = "prod-interne"
  ip_cidr_range = "10.0.3.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.devoir1.self_link
}
resource "google_compute_subnetwork" "prod-traitement" {
  name          = "prod-traitement"
  ip_cidr_range = "10.0.2.0/24"
  region        = "northamerica-northeast1"
  network       = google_compute_network.devoir1.self_link
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = google_compute_network.prod-traitement.name
  allow {
    protocol = "tcp"
    ports    = ["2846","5462"]
  }

}

resource "google_compute_firewall" "http" {
  name    = "http"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

}
© 2020 GitHub, Inc.
