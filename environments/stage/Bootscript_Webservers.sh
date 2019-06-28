#!bin/bash
#Bootscript for web WebServers

sudo yum update -y
yum install httpd -y
cd /var/www/html
echo "<html><h1>This is a WebServer</h1></html>" > index.html
service httpd start
chkconfig httpd on
