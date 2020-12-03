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

data "aws_ami" "mancave" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}

resource "aws_launch_configuration" "as_conf" {
  name            = "web_config"
  #name_prefix    = "mancave-instance"
  image_id        = "${data.aws_ami.mancave.id}" 
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.allow_ssh.id}"]
  user_data       = "${file("userdata.sh")}"
}

resource "aws_autoscaling_group" "ec2" {
  name                      = "mancavetest"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  availability_zones        = ["us-east-1a", "us-east-1c"]
  target_group_arns         = ["${aws_lb_target_group.test.arn}"]
  tag {
    key                 = "test"
    value               = "success"
    propagate_at_launch = false
  }
}

resource "aws_lb" "alb_mancave" {
  name               = "mancave-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_ssh.id}"]
  subnets            = data.aws_subnet_ids.mancave.ids
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-30ca1b4d"
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.alb_mancave.arn}"
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test.arn}"
  }
}

##################################################################
# Data sources to get VPC and subnets
##################################################################
data "aws_subnet_ids" "mancave" {
  vpc_id = "vpc-30ca1b4d"
}

##################################################################
# ROUTE 53
##################################################################
resource "aws_route53_zone" "mancave" {
  name = "mancave.com"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.mancave.zone_id}"
  name    = "example.com"
  type    = "A"

  alias {
    name                   = "${aws_lb.alb_mancave.dns_name}"
    zone_id                = "${aws_lb.alb_mancave.zone_id}"
    evaluate_target_health = true
  }
}