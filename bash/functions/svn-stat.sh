#!/bin/bash
#===============================================================================
#
#          FILE:  svn-stat.sh
# 
#         USAGE:  ./svn-stat.sh 
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
#       CREATED:  01/15/2016 08:49:12 AM EET
#      REVISION:  ---
#===============================================================================

function svn-stat () {
    # check for 'svn' binary
    if ! svn --version > /dev/null 2>&1;then
        echo "Can't find 'svn' on the PATH, please install it..."
        return 2;
    fi
    # display status on wd, but skip modify, delete and added files
    svn st | egrep -v '^M|D|A'
}


