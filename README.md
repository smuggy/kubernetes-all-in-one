# Kubernetes K3S all-in-one node installation

Currently, terraform to create k3s cluster leveraging scripts.

* Create aws instance in the default vpc in us-east-2 by using the Terraform in the resources directory
* Terraform will create the ssh key pair with the private key in the `secrets` directory
* Terraform will put the kube config file in the `secrets` directory as well
