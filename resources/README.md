# Resource provisioning

The resources necessary to create a kubernetes cluster on 
aws ec2 one instance.

Resources created include:
* security group
  * open ingress and egress
* key pair
  * private key in secrets directory
  * aws key pair created and used for instance
* ec2 instance
  * t3a.medium instance type
  * ubuntu operating system
* looks up default vpc
