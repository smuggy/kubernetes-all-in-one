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

resource "ssh_resource" "config_k9s" {
  depends_on = [
    ssh_resource.retrieve_config
  ]
  host = local.public_ip
  commands = [
    "sudo mkdir --parents /root/.kube && sudo cp /etc/rancher/k3s/k3s.yaml /root/.kube/config",
    "wget https://github.com/derailed/k9s/releases/download/v0.50.15/k9s_Linux_amd64.tar.gz",
    "tar --extract --file k9s_Linux_amd64.tar.gz",
    "sudo mv k9s /usr/local/bin/k9s",
    "mkdir --parents /home/ubuntu/.kube && sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config",
    "sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config",
    "rm --force k9s_Linux_amd64.tar.gz LICENSE README.md"
  ]
  user        = local.user_name
  private_key = tls_private_key.ssh_key.private_key_pem # var.ssh_private_key_pem
}

resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/../secrets/%s", path.root, "kube_config_server.yaml")
  content  = ssh_resource.retrieve_config.result
}
