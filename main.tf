terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_account" "account_info" {}

output "droplet_limit" {
  value = data.digitalocean_account.account_info.droplet_limit
}


data "digitalocean_ssh_key" "mySSHKey" {
  name = "mac"
}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-18-04-x64"
  name     = "web-1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.mySSHKey.id]
}

output "server_ip" {
  value = digitalocean_droplet.web.ipv4_address
}
