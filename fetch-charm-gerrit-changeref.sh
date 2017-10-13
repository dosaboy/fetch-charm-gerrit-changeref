#!/bin/bash -eu
#
# Fetch openstack charm patchset from review.openstack.org and store locally
#
(($#==3)) || { echo "USAGE: `basename $0` <repository-name> <gerrit-changeref> <patchset> [<ubuntu-series>]"; exit 1; }
REPO=$1
CHANGEREF=$2
PATCHSET=$3
SERIES=${4:-xenial}
mkdir -p $SERIES
url=https://review.openstack.org/openstack/$REPO
ref=refs/changes/${CHANGEREF: -2}/$CHANGEREF/$PATCHSET
charm=$SERIES/`echo $REPO| sed -r 's/charm-()/\1/'`
echo "Fetching change $CHANGEREF patchset $PATCHSET from $url"
[ -d $charm ] || git clone --depth 1 --no-checkout $url $charm
(cd $charm; git fetch --depth 1 $url $ref; git checkout FETCH_HEAD;)
echo "You can now add 'local:$charm' to your bundle"