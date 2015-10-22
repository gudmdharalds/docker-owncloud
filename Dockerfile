
# Use CentOS 7.1 as base
FROM centos:7.1.1503

MAINTAINER Gudmundur Haraldsson <gdh1@hi.is> 

VOLUME ["/var/lib/owncloud"]

RUN yum makecache fast

# Install the packages we need - MariaDB-libs, utils, 
# and also EPEL so we can install owncloud 
RUN yum install -y mariadb-libs hostname epel-release

# Update caches
RUN yum makecache fast

# Install owncloud and relevant updates
RUN yum install -y owncloud
RUN yum update -y
RUN yum clean all

# If, during build, no config-file exists in /var/lib/owncloud (the 
# persistant volume storage), then copy the existing /etc/owncloud/config.php 
# to the volume. Also, create a symbolic link to the file from /etc/owncloud/config.php.
#
# A script will take care of creating /var/lib/owncloud/config.php.

RUN mv /etc/owncloud/config.php /etc/owncloud/config-orig.php && \
    ln -s /var/lib/owncloud/config.php /etc/owncloud/config.php 

# Enable apache to write to all folders and files it 
# needs write-access to.
RUN chown apache:apache /etc/owncloud/config-orig.php && chmod 0700 /etc/owncloud/config-orig.php && \
    chown apache:apache /var/log/httpd/ /var/run/httpd/

# Allow access from anywhere
RUN ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf

# Alter configuration file so that Apache will try to 
# start server on port 8080
RUN sed 's/Listen 80$/Listen 8080/' -i /etc/httpd/conf/httpd.conf && \
    sed 's/ServerAdmin root\@localhost$/ServerAdmin admin@yourdomain.com/' -i /etc/httpd/conf/httpd.conf 

# This webserver will run as non-root, on port 8080
EXPOSE 8080
USER apache

ENTRYPOINT /usr/sbin/httpd -DFOREGROUND

