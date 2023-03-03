terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.36.2"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    ssh = {
      source = "loafoe/ssh"
    }
  }
}

# Define Hetzner provider token
provider "hcloud" {
  token = var.hcloud_token
}

provider "tls" {
  # Configuration options
}
