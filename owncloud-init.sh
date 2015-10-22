#!/bin/bash

function sysexit {
        echo "ERROR: $1"
        exit 1
}

if [ -d "$OWNCLOUD_DATA_DIR" ] ; then
        sysexit "Instance seems to exist."
fi

if [ -f "$OWNCLOUD_DATA_DIR/config.php" ] ; then
        sysexit "Instance seems to exist (config-file exists)"
fi

docker run -d --volume="$OWNCLOUD_DATA_DIR:/var/lib/owncloud/" --entrypoint=/bin/bash --user=root -t owncloud -c \
"mkdir -p /var/lib/owncloud/data /var/lib/owncloud/apps && \
cp /etc/owncloud/config-orig.php /var/lib/owncloud/config.php && \ 
chown -R apache:apache /var/lib/owncloud && \
chmod -R u+rwx /var/lib/owncloud && \ 
chmod -R og-wx /var/lib/owncloud/ "

echo "Owncloud instance in $OWNCLOUD_DATA_DIR initialized and is ready for use."
