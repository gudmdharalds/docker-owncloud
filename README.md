
This is a dockerfile for Owncloud, based on CentOS 7.1. Included are MariaDB libraries, enabling MariaDB/MySQL database servers to be used as a backend for owncloud. The dockerfile provides a shared-file volume for storing configuration files, addon-apps, and stored files - the location of which can be customized. Further, this setup allows for multiple Owncloud-instances to run simultainously. The webserver included is Apache, and is configured to run as non-root user.



## Installation

Setup of this Owncloud dockerfile might be as follows:

```

unzip docker-owncloud.zip 

docker build -t owncloud docker-owncloud

cd docker-owncloud

export OWNCLOUD_SHARED_DATA_DIR="/home/docker/data-dir-for-owncloud"

export OWNCLOUD_INSTANCE=1944

export OWNCLOUD_LISTEN_PORT=8200

./owncloud-init.sh

./owncloud-firststart.sh

```

This instance of Owncloud would run within a container named owncloud-1944, and would be accessible via 127.0.0.1 on port 8022. Point your browser to this location to complete installation.

NOTE: For security reasons, do not expose Owncloud outside your local machine until finishing the installation (which is done via browser). If you do this, you might be exposing your Owncloud-instance to various risks. Only after installing and configuring, you can safely expose it outside your local machine.

## Starting and stopping

After the initial steps have been taken, it is save to start the docker image with `docker start owncloud`, and to stop with `docker stop owncloud`.

