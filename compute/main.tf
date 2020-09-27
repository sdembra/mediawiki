provider "aws" {
  region = "us-west-2"
  profile = "mediawiki"
}

data "aws_availability_zones" "data_az" {
  
}

#-------------- Key-Pair --------------#
resource "aws_key_pair" "mw_key_pair" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


#-------------- AWS Instances --------------#
resource "aws_instance" "mw_instance_jump_host" {
  ami = "${var.ami}"
  #ami = "ami-009816cdbb1e74ceb"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.jump_host_security_group}"]
  subnet_id = "${var.jump_host_subnet}"
  source_dest_check = "false"
  #user_data = "${data.template_file.web_init.rendered}"
  tags{
    Name = "mw_instance_jump_host"
    Project = "mediawiki"
  }
}

resource "aws_instance" "mw_instance_web_a" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.web_security_group}"]
  subnet_id = "${var.web_subnet_a}"
  user_data = "${data.template_file.web_init.rendered}"
  tags{
    Name = "mw_instance_web_a"
    Project = "mediawiki"
  }
}

#resource "aws_instance" "mw_instance_web_b" {
#  ami = "${var.ami}"
#  instance_type = "${var.web_instance_type}"
#  key_name = "${aws_key_pair.mw_key_pair.id}"
#  vpc_security_group_ids = ["${var.web_security_group}"]
#  subnet_id = "${var.web_subnet_b}"
#  user_data = "${data.template_file.web_init.rendered}"
#  tags{
#    Name = "mw_instance_web_b"
#    Project = "mediawiki"
#  }
#}

resource "aws_instance" "mw_instance_db" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  key_name = "${aws_key_pair.mw_key_pair.id}"
  vpc_security_group_ids = ["${var.db_security_group}"]
  subnet_id = "${var.db_subnet}"
  user_data = "${data.template_file.db_init.rendered}"
  tags{
    Name = "mw_instance_db"
    Project = "mediawiki"
  }
}

data "template_file" "web_init" {
   template = "${file("${var.web_user_data}")}"
   vars {
    }

}

data "template_file" "db_init" {
   template = "${file("${var.db_user_data}")}"
   vars {
    }

}
#-------------- ELB --------------#
resource "aws_elb" "mw_elb" {

  name = "media-wiki-elb"
  subnets = ["${var.jump_host_subnet}", "${var.public_subnet_b}"]
  #instances = ["${aws_instance.mw_instance_web_a.id}", "${aws_instance.mw_instance_web_b.id}"]
  instances = ["${aws_instance.mw_instance_web_a.id}"]
  security_groups = ["${var.web_security_group}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    timeout             = "3"
    target              = "TCP:80"
    interval            = "30"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "mw_elb"
    Project = "mediawiki"
  }
}

resource "aws_lb_cookie_stickiness_policy" "mw_lb_policy" {
  name                     = "mw-lb-policy"
  load_balancer            = "${aws_elb.mw_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}
