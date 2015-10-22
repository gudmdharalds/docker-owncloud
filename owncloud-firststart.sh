#!/bin/bash

function sysexit {
        echo "ERROR: $1"
        exit 1
}

if [ "$OWNCLOUD_DATA_DIR" == "" ] ; then
	sysexit "No data dir specified. Specify using OWNCLOUD_DATA_DIR environment variable. "
fi

if [ ! -d "$OWNCLOUD_DATA_DIR" ] ; then
        sysexit "Instance seems not to exist."
fi

#
# Figure out if this instance is still running
#

RUNNING=`docker inspect owncloud 2>/dev/null |grep "\"Running\":" |grep true`;

# Empty string means it is not running
if [ "$RUNNING" != "" ] ; then
        sysexit "It seems that docker container is running already"
fi

#
# Figure out if another container is using the owncloud label
#

docker inspect owncloud >/dev/null 2>&1

if [ $? == 0 ] ; then
	# Another instance bears this same name -- get it out of the way
        docker rename owncloud owncloud-`date +%s`
fi


docker run -d --volume="$OWNCLOUD_DATA_DIR/:/var/lib/owncloud/" --publish=127.0.0.1:8080:8080 --name owncloud -t owncloud

