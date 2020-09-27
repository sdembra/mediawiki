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
sudo su -

PRIVATE_IP=`curl --silent http://169.254.169.254/latest/meta-data/local-ipv4`
echo $PRIVATE_IP
sleep 5
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
subscription-manager repos --enable=rhel-7-server-optional-rpms
yum-config-manager --enable remi-php72
yum install -y httpd >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install httpd package."
fi
yum install -y php72 >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install php package."
fi
yum install -y "php-mysql" >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install php-mysql package."
fi
yum install -y "php-gd" >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install php-gd package."
fi
yum install -y "php-xml" >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install php-xml package."
fi
yum install -y "php-mbstring" >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install php-mbstring package."
fi
yum install -y wget >> /tmp/b
if [ $? -ne 0 ];then
  echo "ERROR: could not install wget package."
fi
cd /root/
wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.2.tar.gz
#cd /var/www/
cd /var/www/html/
tar -zxf /root/mediawiki-1.34.2.tar.gz
ln -s mediawiki-1.34.2/ mediawiki
chown -R apache.apache /var/www/mediawiki
service httpd restart
setenforce 0
echo "JSK" >> /tmp/a.txt
##################################### USER DATA END #######################################
) 2>&1)  | logit
