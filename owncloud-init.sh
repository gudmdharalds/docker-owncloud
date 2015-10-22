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


OWNCLOUD_INSTANCE_DATA_DIR="$OWNCLOUD_SHARED_DATA_DIR/$OWNCLOUD_INSTANCE"

if [ -d "$OWNCLOUD_INSTANCE_DATA_DIR" ] ; then
        sysexit "Instance seems to exist."
fi

if [ -f "$OWNCLOUD_INSTANCE_DATA_DIR/config.php" ] ; then
        sysexit "Instance seems to exist (config-file exists)"
fi


docker run -d --volume="$OWNCLOUD_INSTANCE_DATA_DIR:/var/lib/owncloud/" --entrypoint=/bin/bash --user=root -t owncloud -c \
"mkdir -p /var/lib/owncloud/data /var/lib/owncloud/apps && \
cp /etc/owncloud/config-orig.php /var/lib/owncloud/config.php && \ 
chown -R apache:apache /var/lib/owncloud && \
chmod -R u+rwx /var/lib/owncloud && \ 
chmod -R og-wx /var/lib/owncloud/ "

echo "Owncloud instance $OWNCLOUD_INSTANCE (in $OWNCLOUD_INSTANCE_DATA_DIR) initialized and is ready for use."
