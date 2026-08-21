provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://100.48.211.139:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "cbb2952f-bbd0-ac4e-f98c-62e19d047419"
      secret_id = "64c4eb4c-8677-5a79-f2ad-db8d74a7c041"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
