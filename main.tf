provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_configuration" "example" {
  image_id                    = "ami-40d28157"
  instance_type          = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  //user_data allows multiline commands to be inserted
  user_data = <<-EOF
  #!/bin/bash
  echo "Derp" > index.html
  nohup busybox httpd -f -p "${var.server_port}" &
  EOF
  
  lifecycle{
    create_before_destroy = true
  }

}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}



resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle{
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example"{
  launch_configuration ="${aws_launch_configuration.example.id}"
min_size = 2
max_size = 10

tag{
  key = "Name"
  value = "terraform-asg-example"
  propagate_at_launch = true
}


}
//Left off on page 69...lol

