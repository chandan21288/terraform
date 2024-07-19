provider "aws" {
  region = "ap-southeast-2"
}

data "aws_secretsmanager_secret" "my-key" {
  name = "my-key"
}

data "aws_secretsmanager_secret_version" "my-key_version" {
  secret_id = data.aws_secretsmanager_secret.my-key.id
}

locals {
  aws_secrets = jsondecode(data.aws_secretsmanager_secret_version.my-key_version.secret_string)
}

provider "aws" {
  alias      = "with_secrets"
  access_key = local.aws_secrets["AWS_ACCESS_KEY_ID"]
  secret_key = local.aws_secrets["AWS_SECRET_ACCESS_KEY"]
  region     = "ap-southeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-03f0544597f43a91d"
  instance_type = "t2.micro"
  provider      = aws.with_secrets
}

