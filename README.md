
This is a dockerfile for Owncloud, based on CentOS 7.1. Included are MariaDB libraries, enabling MariaDB/MySQL database servers to be used as a backend for owncloud. The dockerfile provides a shared-file volume for storing configuration files, addon-apps, and stored files - the location of which can be customized. 


## Installation

Setup of this Owncloud dockerfile might be as follows:

```

unzip docker-owncloud.zip 

docker build -t owncloud docker-owncloud

cd docker-owncloud

export OWNCLOUD_DATA_DIR="path-to-data-dir"

./owncloud-init.sh

./owncloud-firststart.sh

```

After these steps have been taken, it is save to start the docker image with `docker start owncloud`, and to stop with `docker stop owncloud`.

