output "server_ip_debian11" {
 value = hcloud_server.debian11.ipv4_address
}

output "access_private_key_pem" {
    value = tls_private_key.access.private_key_pem
    sensitive = true
}

output "access_public_key" {
    value = tls_private_key.access.public_key_openssh
}

# output "result" {
#   value = try(jsondecode(ssh_resource.install_docker.result), {})
# }