#!/bin/bash
#===============================================================================
#
#          FILE:  mysql-add-db.sh
# 
#         USAGE:  ./mysql-add-db.sh 
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
#       CREATED:  01/19/2016 06:23:23 AM EET
#      REVISION:  ---
#===============================================================================

function mysql-add-db () {
    # database schema template
    DBT="/var/www/schema.sql";
    HOST="127.0.0.1";
    PASS=$(apg -n1 -m8 -x8 -MCNL -t);
    #
    if [ -z "${1}" ];then
        echo "Usage ${FUNCNAME} [db_name] {db_user} {db_pass} {db_source}!";
        echo "Default db source is ${DBT}";
        return 1;
    else DBNAME="${1}"; fi;
    if [ -z "${2}" ];then DBUSER="${1}"; else DBUSER="${2}"; fi
    if [ -z "${3}" ];then DBPASS=$(echo ${PASS} | cut -f1 -d' '); else DBPAS="${3}"; fi;
    if [ -z "${4}" ];then DBSOURCE=${DBT}; else DSOURCE="${4}"; fi;
    #
    if [ ! -f "${DBSOURCE}" ];then echo "Source db ${DBSOURCE} doesn't exist, exiting.."; return 2; fi;
    #
    echo -n "Creating database ${DBNAME} ... ";
    mysql -u root -e "CREATE DATABASE ${DBNAME};
                      GRANT all on ${DBNAME}.* to '${DBUSER}'@'${HOST}' identified by '${DBPASS}';"
    if [ "$?" -eq "0" ];then echo "done!"; else echo "fail!"; return 3;fi
    #
    echo -n "Populating database... ";
    mysql -u root ${DBNAME} < ${DBSOURCE};
    if [ "$?" -eq "0" ];then echo "done!"; else echo "fail!"; return 4;fi
    #
    echo "Succesufuly create database '${DBNAME}', with user '${DBUSER}' and pass '${PASS}' from template '${DBSOURCE}'";
}
