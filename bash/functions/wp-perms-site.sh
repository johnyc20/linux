#!/bin/bash
#===============================================================================
#
#          FILE:  wp-perms.sh
#
#         USAGE:  ./wp-perms.sh
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
#       CREATED:  01/13/2016 01:26:51 PM EET
#      REVISION:  ---
#===============================================================================


function wp-perms-site () {
    WD="/var/www";
    case "${2}" in
        perm|permissive)
            perms="o+w";
            phperms="666";
        ;;
        rest|restrictive)
            perms="o-w";
            phperms="444";
        ;;
        *)
            echo "Use ${FUNCNAME} [site-name] [perm(issive)|rest(rictive)]!";
            return 1;
        ;;
    esac;
    #WRDS=$(find ${WD} -maxdepth 2 -user florin -type d -name 'wp-content' | cut -f4 -d'/' | sort | uniq );
    if [[ -d ${WD}/${1} ]];then
        echo "Setting permissions ${1} on WP ${1}:"
        chmod -R ${perms} ${WD}/${1};
        find ${WD}/${rd} -type f -name '*.php' -exec chmod ${phperms} {} \;
        echo "done";
    else
        echo "The directory ${WD}/${1} doesn't exist!"
    fi;
}
