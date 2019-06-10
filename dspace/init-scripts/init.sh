#!/bin/sh
# Once this file has been saved to a docker volume, the ingest step will not be re-run
CHECKFILE=/dspace/assetstore/ingest.hasrun.flag

# Shell scripts are unable to pass environment variables containing a period.
# By DSPACE convention, a double underbar will be used to set such variables.
#
#   dpsace__path=/dspace --> dspace.path=/dspace
#
# DSpace 7 is able to make this conversion in Apache Commons Config code.
#
# The following script code is designed to provide similar flexibility to earlier
# versions of DSpace running in docker.

# Overwrite local.cfg for DSpace 6
# __D__ -> -
# __P__ -> .
env | egrep "__.*=" | egrep -v "=.*__" | sed -e s/__P__/\./g | sed -e s/__D__/-/g > /dspace/config/local.cfg


export JAVA_OPTS="${JAVA_OPTS} -Xmx2500m -Dupload.temp.dir=/dspace/upload -Djava.io.tmpdir=/tmp"

if [ ! -f $CHECKFILE ]
then
  # On the first startup of a new DSpace instance, this script will run the background

  echo "is first time this container run"
  touch $CHECKFILE
fi

catalina.sh run
