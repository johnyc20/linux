#!/bin/bash
# ---------------------------------------------------------------------------
# svn-add-wp.sh

# 2015, Mocanu Silviu <johnyc20@gmail.com>

# Usage: svn-add-wp.sh [vhost]

# Revision history:
# 2015-12-24  Created

# ---------------------------------------------------------------------------

WD="/var/www";
SVNUSER="svnuser";
SVNHOST="192.168.0.1";
SVNPATH="/path-to-repo";
# my defs
source /etc/scrips.defs
SVNURL="svn+ssh://${SVNUSER}@${SVNHOST}/${SVNPATH}";
IGNORE="${WD}/wp-ignore.svn";

## usage function
function usage () {
    echo "Usage $0 [vhost]";
    exit 1;
}

## check if empty arg
[[ ! ${1} ]] && usage;

## check if dir exists and work on it.
if [ -d ${WD}/${1} ];then
    site=${1};
    echo "***Entring directory: ${WD}/${site} "
    ## importing trd
    cd ${WD}
    svn import --depth=empty ${site} ${SVNURL}/${site} -m "ci"
    cd ${WD}/${site}
    svn co ${SVNURL}/${site} ../${site}
    ## Ignore
    echo "Ignoring files/directories from ${IGNORE} file..."
    svn propset svn:ignore -F ${IGNORE} .
    for i in $(cat ${IGNORE});do
        if [[ -d ${i} ]];then
	    for p in ${i//\// }; do
	        svn add -N ${p};
	    done;
	    svn add -N ${i};
	    svn ci -m "ci, ${site}, ignoring ${i} ... "
	    svn propset svn:ignore '*' ${i};
        fi;
    done
    svn ci -m "ci, ${site}, ignore..."
    ## add rest
    echo "Adding rest of the files ..."
    svn st | grep '^?' | awk '{print $2}' | xargs svn add > /dev/null
    svn ci -m 'ci'
    svn update
    echo "upper.."
    cd ..
## if directory doesn't exists
else
    usage;
fi;
