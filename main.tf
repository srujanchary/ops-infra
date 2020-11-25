resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "ssh"
  vpc_id      = "vpc-30ca1b4d"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Java"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alow ssh"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKHWuNkpKZ/MEhysjzgGScW8MF2E+gQSLx3huchQOysve6V8c8vGwfoqEVx3Vn25eJUJhFDAyjQ21TvuD4pss9gH8LIot+3G8OtIuAzQOANcmhJZpnfiP8125g5hTmbOt3asNfnM1KkNViuZV2v8lemI/glx29a9d6E2eElhhWij9RCXYHK21wRKgJ2pWxBAx9VSzyqlbkmCWhiAFq9RYyvtOuAWsyXdbQksHyCuWUR9pNkP/1Px2NSYoPdqP3fPoRVQPSRGKNqXnEnjIdOJU1m2nEH3islerEvBF7iMAi68sXk6LMuyo+/EwnZFCgiLjuvk8JgpzvBRdiSB5zRgmx srujan.chary@C-0272"
}
resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = "ami-04bf6dcdc9ab498ca" 
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.allow_ssh.id}"]
}

resource "aws_autoscaling_group" "ec2" {
  name                      = "mancave-test"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  availability_zones        = ["us-east-1a", "us-east-1c"]
  tag {
    key                 = "test"
    value               = "success"
    propagate_at_launch = false
  }
}