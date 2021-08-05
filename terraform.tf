terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.78.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
  backend "local" {
    path = "./state/local.tfstate"
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}
