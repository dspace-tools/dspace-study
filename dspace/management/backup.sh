#!/bin/bash

SITE_PREFIX=$(cat /dspace/config/dspace.cfg | grep 'handle.prefix =' | awk '{ OFS=" "; print $3 }')
DATE=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR=/backups/$DATE


mkdir -p $BACKUP_DIR
/dspace/bin/dspace packager -u -d -a -t AIP -e test@test.edu -i $SITE_PREFIX/0 $BACKUP_DIR/sitewide-aip.zip