# Kubernetes all-in-one node installation

Currently, ansible uses kubeadm to create a version 1.33 kubernetes cluster.

1. create aws instance in the default vpc in us-east-2 by using the terraform in the resources directory
2. configure the instance using the ansible defined in the configuration directory

Terraform will create the ssh key pair with the private key in the secrets directory.

For the configuration, the python env can be done in this root, or in the configuration directory.

The cluster has the following:
* version 1.33 of Kubernetes
* created with kubeadm
* no csi has been installed
* no ingress controller has been installed
