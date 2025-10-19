resource "ssh_resource" "install_k3s" {
  host = local.public_ip
  commands = [
    "bash -c 'curl https://get.k3s.io | INSTALL_K3S_EXEC=\"server --node-external-ip ${local.public_ip} --node-ip ${local.private_ip}\" sh -'"
  ]
  user        = local.user_name
  private_key = tls_private_key.ssh_key.private_key_pem
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.install_k3s
  ]
  host = local.public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${local.public_ip}/g\" /etc/rancher/k3s/k3s.yaml"
  ]
  user        = local.user_name
  private_key = tls_private_key.ssh_key.private_key_pem # var.ssh_private_key_pem
}

resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/../secrets/%s", path.root, "kube_config_server.yaml")
  content  = ssh_resource.retrieve_config.result
}
