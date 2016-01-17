#!/bin/bash
#===============================================================================
#
#          FILE:  svn-ign-dir.sh
# 
#         USAGE:  ./svn-ign-dir.sh 
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
#       CREATED:  01/15/2016 08:33:37 AM EET
#      REVISION:  ---
#===============================================================================

function svn-ign-dir () {
    # check for 'svn' binary
    if ! svn --version > /dev/null 2>&1;then
        echo "Can't find 'svn' on the PATH, please install it..."
        return 2;
    fi
    # check id dir exist
    if [[ -d "${1}" ]];then 
        cd "${1}"
        svn ps svn:ignore '*' .
        svn st
    else
        echo "Usage ${FUNCNAME} [directory]!"
    fi 
}
