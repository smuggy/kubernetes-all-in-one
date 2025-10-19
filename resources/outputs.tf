output "public_ip" {
  value = aws_instance.node.public_ip
}

output "k9s_install" {
  value = ssh_resource.config_k9s.result
}
