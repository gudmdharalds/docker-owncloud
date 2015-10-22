#!/bin/bash

function sysexit {
        echo "ERROR: $1"
        exit 1
}

if [ "$OWNCLOUD_INSTANCE" == "" ] ; then
        sysexit "Please specify instance (e.g., 1 or photos) via environment variable OWNCLOUD_INSTANCE"
fi

if [ "$OWNCLOUD_SHARED_DATA_DIR" == "" ] ; then
        sysexit "Please specify folder for shared files via environment variable OWNCLOUD_SHARED_DATA_DIR (e.g., /home/docker/data/owncloud-instances)"
fi

if [ "$OWNCLOUD_LISTEN_PORT" == "" ] ; then
	OWNCLOUD_LISTEN_PORT=8080
fi

OWNCLOUD_INSTANCE_DATA_DIR="$OWNCLOUD_SHARED_DATA_DIR/$OWNCLOUD_INSTANCE"


if [ ! -d "$OWNCLOUD_INSTANCE_DATA_DIR" ] ; then
        sysexit "Instance seems not to exist."
fi

OWNCLOUD_INSTANCE_NAME="owncloud-$OWNCLOUD_INSTANCE"

#
# Figure out if this instance is still running
#

RUNNING=`docker inspect $OWNCLOUD_INSTANCE_NAME 2>/dev/null |grep "\"Running\":" |grep true`;

# Empty string means it is not running
if [ "$RUNNING" != "" ] ; then
        sysexit "It seems that docker container is running already"
fi

#
# Figure out if another container is using the owncloud label
#

docker inspect $OWNCLOUD_INSTANCE_NAME >/dev/null 2>&1

if [ $? == 0 ] ; then
	# Another instance bears this same name -- get it out of the way
        docker rename $OWNCLOUD_INSTANCE_NAME $OWNCLOUD_INSTANCE_NAME-`date +%s`
fi


docker run -d --volume="$OWNCLOUD_INSTANCE_DATA_DIR/:/var/lib/owncloud/" --publish=127.0.0.1:$OWNCLOUD_LISTEN_PORT:8080 --name $OWNCLOUD_INSTANCE_NAME -t owncloud

