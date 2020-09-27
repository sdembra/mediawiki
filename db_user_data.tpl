#!/bin/bash
logit() {
   while read LINE
   do
      LOGFILE=/var/log/user-data.log
      STAMP=$(date +"%Y-%m-%d %H:%M:%S")
      echo "$STAMP       $LINE" >> $LOGFILE
   done

}

set -x
((
##################################### USER  DATA START ############################################
sudo su

PRIVATE_IP=`curl --silent http://169.254.169.254/latest/meta-data/local-ipv4`
echo $PRIVATE_IP
#echo "SS" >> /tmp/b.txt
sleep 60
yum install -y mariadb-server mariadb
if [ $? -ne 0 ];then
  echo "ERROR: could not install some package."
fi
systemctl start mariadb
#mysql_secure_installation
mysql -u root  -e "CREATE USER 'wiki'@'%' identified by 'mediawiki'"
mysql -u root  -e "CREATE DATABASE mediawiki"
mysql -u root  -e "GRANT ALL PRIVILEGES ON mediawiki.* TO 'wiki'@'%'"
mysql -u root  -e "FLUSH PRIVILEGES"
systemctl enable mariadb

##################################### USER DATA END #######################################
) 2>&1)  | logit
