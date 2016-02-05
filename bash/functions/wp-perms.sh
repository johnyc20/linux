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


function wp-perms () {
    WD="/var/www";
    case "${1}" in
        perm|permissive)
            perms="o+w";
        ;;
        rest|restrictive)
            perms="o-w";
        ;;
        *)
            echo "Use ${FUNCNAME} [perm(issive)|rest(rictive)]!";
            return 1;
        ;;
    esac;
    WRDS=$(find ${WD} -maxdepth 2 -user florin -type d -name 'wp-content' | cut -f4 -d'/' | sort | uniq );
    echo "Setting permissions ${1} on all wordpress..."
    for wps in ${WRDS};do
        echo -n "Working on ${wps} ...  "
        chmod -R ${perms} ${WD}/${wps};
        echo "done";
    done;
}

