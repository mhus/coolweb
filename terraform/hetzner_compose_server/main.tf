
# Create SSH key
resource "tls_private_key" "access" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Obtain ssh key data
resource "hcloud_ssh_key" "ssh_key" {
  name       = "id_rsa"
  public_key = tls_private_key.access.public_key_openssh
}

# Create Debian 11 server
resource "hcloud_server" "debian11" {
    depends_on = [
      hcloud_ssh_key.ssh_key
    ]
  name = "debian11.computingforgeeks.com"
  image = "debian-11"
  server_type = "cx11"
  ssh_keys  = [hcloud_ssh_key.ssh_key.id]
}

resource "null_resource" "wait_for_ssh" {
  depends_on = [hcloud_server.debian11]

  provisioner "local-exec" {
    command = "while ! nc -z ${hcloud_server.debian11.ipv4_address} 22; do sleep 1; done"
  }
}

resource "null_resource" "install_docker" {
  depends_on = [null_resource.wait_for_ssh]
  provisioner "remote-exec" {
    connection {
        host     = hcloud_server.debian11.ipv4_address
        user     = "root"
        private_key = tls_private_key.access.private_key_pem
    }
    script = "install_docker.sh"
  }
}

# resource "ssh_resource" "install_docker" {
#   depends_on = [
#     hcloud_server.debian11
#   ]
#   host         = hcloud_server.debian11.ipv4_address
#   user         = "root"
#   private_key  = tls_private_key.access.private_key_pem
 
#   file {
#     content     = file("install_docker.sh")
#     destination = "/install_docker.sh"
#     permissions = "0700"
#   }

#   timeout = "5m"

#   commands = [
#     "/install_docker.sh",
#   ]
# }