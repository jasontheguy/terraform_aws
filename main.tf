provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-09bfeda7337019518"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }
}
