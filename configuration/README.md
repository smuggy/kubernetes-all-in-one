# Ansible configuration

After the terraform creates the instance, set up ansible for this:

```shell
python3 -m venv ./env
. env/bin/activate
python3 install ansible
```

Then run the configuration:

```shell
ansible-playbook server.yaml
```

This should do the following:
* install containerd and packages via apt
* install kubernetes tools
  * kubectl
  * kubeadm
  * kubelet
* initiate cluster with kubeadm command 

The kube config file is put in the root home .kube directory.
