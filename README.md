# mediawiki
This project creates following AWS resources:
- VPC, public subnet, private subnet, internet gateway, NAT gateway, route tables.
- instances running http and mariadb in private subnet.
- ELB in front of http servers.

Prerequisites:
- terraform version 0.11 installed.t
- create ssh key pair using ssh-keygen command. 
  Provide key file path as /root/.ssh/media_wiki (or ~/.ssh/media_wiki)
- Attaching terraform 0.11 binary for reference.
- Create a AWS profile having admin access in /root/.aws/credentials file with name mediawiki.
eg. Add following lines in /root/.aws/credentials file: 
[mediawiki]
aws_access_key_id = XXXXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
Else you can use appropriate profile in terraform.tfvars file present in the code.

Before running terraform init/plan/apply, validate the variables in terrafor.tfvars file.
Run
$ terraform init --reconfigure
$ terraform pan -var-file terraform.tfvars
$ terrafom apply -var-file terrafor.tfvars

Implementation details:
web_user_data.tpl takes care of configuring yum-repo, installing httpd and php. It also installs mediawiki.
db_user_data.tpl takes care of installting mariadb-server and mariadb and also creating 'mediawiki' database and 'wiki' user in mysql.

After terraform is applied, access the ELB from browser. (Get the DNS resolvable name from AWS console)
Set up media wiki.
mysql user/password for mediawiki database is "wiki/mediawiki"
You can get the IP address of DB server from AWS console or from terraform state file.
