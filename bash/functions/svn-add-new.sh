#!/bin/bash
#===============================================================================
#
#          FILE:  svn-add-new.sh
# 
#         USAGE:  ./svn-add-new.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Silviu Mocanu (), johnyc20@gmail.com
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  01/15/2016 08:45:29 AM EET
#      REVISION:  ---
#===============================================================================

function svn-add-new () {
    # check for 'svn' binary
    if ! svn --version > /dev/null 2>&1;then
        echo "Can't find 'svn' on the PATH, please install it..."
        return 2;
    fi
    # add new files to repo
    svn st | grep '^?' | awk '{print $2}' | xargs svn add
}
