locals {
  key_name = "mm-test-key"
}

resource "aws_security_group" "this" {
  name   = "kubernetes_sg"
  vpc_id = local.vpc_id
  tags = {
    Name = "kubernetes_node_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "open_inbound" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "open all ports for inbound access"
  tags = {
    Name = "open-inbound"
  }
}

resource "aws_vpc_security_group_egress_rule" "open_outbound" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "open all ports for outbound access"
  tags = {
    Name = "open-outbound"
  }
}

resource "aws_instance" "node" {
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = local.subnet_id # data.aws_subnet.a.id
  instance_type          = "t3a.medium"
  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  }

  tags = {
    Name       = "mm-test-instance"
    Source     = "local-tf"
    CostCenter = "268"
  }
  depends_on = [aws_key_pair.this]
}

