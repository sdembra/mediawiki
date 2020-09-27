output "mw_jump_host_public_ip" {
  value = "${aws_instance.mw_instance_jump_host.public_ip}"
}

output "mw_web_a_private_ip" {
  value = "${aws_instance.mw_instance_web_a.private_ip}"
}

#output "mw_web_b_private_ip" {
#  value = "${aws_instance.mw_instance_web_b.private_ip}"
#}

output "mw_db_private_ip" {
  value = "${aws_instance.mw_instance_db.private_ip}"
}

