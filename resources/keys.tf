resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key_file" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "../secrets/private-key.pem"
  file_permission      = 0400
  directory_permission = 0700
}

resource "local_file" "public_key_file" {
  content              = tls_private_key.ssh_key.public_key_openssh
  filename             = "../secrets/public-key.pem"
  file_permission      = 0444
  directory_permission = 0700
}

resource "aws_key_pair" "this" {
  key_name   = local.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
  tags = {
    Name = "mm-kube-access"
    Use  = "instance access"
  }

  depends_on = [local_file.public_key_file, local_sensitive_file.private_key_file]
}
