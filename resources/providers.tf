provider "aws" {
  region = "us-east-2"
}

provider "tls" {
}

provider "local" {
}

terraform {
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
  }
}
