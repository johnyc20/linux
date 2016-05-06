#!/bin/bash
#===============================================================================
#
#          FILE:  svn-update-site.sh
# 
#         USAGE:  ./svn-update-site.sh 
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
#       CREATED:  05/06/2016 09:13:11 PM EEST
#      REVISION:  ---
#===============================================================================

WD="/var/www"
#DEBUG=1

if [ -z "${1}" ] || [ ! -d "${WD}/${1}" ];then
    echo "Usage ${0} sitename!"
    exit;
fi
SITE="${1}"
STAT=$(svn status ${SITE})

if svn info ${SITE} > /dev/null 2>&1 && [[ ${STAT} != '' ]];then
    if [[ $(svn st ${SITE} | grep '^?') != '' ]];then
        echo "***Add new files to repo.."
         svn st ${SITE} | grep '^?' | awk '{print $2}' | xargs svn add
    fi;

    if [[ $(svn st ${SITE} | grep '^!') != '' ]];then
        echo "***Remove missing files..."
        svn st ${SITE} | grep '^!' | awk '{print $2}' | xargs svn rm
    fi;

    if [[ $(svn st ${SITE} | grep -v '~       media' ) != '' ]];then
        echo "***Commiting changes for site ${SITE}..."
        if [[ -L ${SITE}/media ]];then
            MEDIASRC=$(readlink -f ${SITE}/media);
            rm -f ${SITE}/media; 
            svn ci ${SITE} -m "commit"
            ln -s ${MEDIASRC} ${SITE}/media
        else
            svn ci ${SITE} -m "commit"
        fi;
    fi;
else
    [[ ${DEBUG} ]] && echo "Site ${SITE} is up2date!"
fi
