// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("/home/vagrant/my-first-project-devops-244309-9e678333d35b.json")}"
  project     = "sny-oss-trf-01-01-00"
  region      = "us-west1-a"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "my-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata = {
    ssh-keys = "aurelio_falleti:${file("~/.ssh/id_rsa.pub")}"
  }
}
