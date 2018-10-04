provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-09bfeda7337019518"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  //user_data allows multiline commands to be inserted
  user_data = <<-EOF
  #!/bin/bash
  echo "Derp" > index.html
  nohup busybox httpd -f -p "${var.server_port}" &
  EOF

  tags {
    Name = "terraform-example"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//Left off on page 69...lol

