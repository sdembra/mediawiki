provider "aws" {
  region = "us-west-2"
#  profile = "mediawiki"
}

module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
  ami = "${var.ami}"
  key_name = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  aws_profile = "${var.aws_profile}"
  web_user_data = "${var.web_user_data}"
  db_user_data = "${var.db_user_data}"

  web_instance_type = "${var.web_instance_type}"
  web_security_group = "${module.network.web_security_group}"
  
  jump_host_security_group = "${module.network.jump_host_security_group}"

  db_instance_type = "${var.db_instance_type}"
  db_security_group = "${module.network.db_security_group}"

  web_subnet_a = "${module.network.web_subnet_a}"
  web_subnet_b = "${module.network.web_subnet_b}"
  public_subnet_b = "${module.network.public_subnet_b}"
  jump_host_subnet = "${module.network.jump_host_subnet}"
  db_subnet = "${module.network.db_subnet}"
}
