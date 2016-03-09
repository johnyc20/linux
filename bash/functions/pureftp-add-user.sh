#!/bin/bash
#===============================================================================
#
#          FILE:  pureftp-add-user.sh
#
#         USAGE:  ./pureftp-add-user.sh
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
#       CREATED:  01/20/2016 10:38:10 AM EET
#      REVISION:  ---
#===============================================================================

function pureftp-add-user () {
    #
    if ! pure-pw list > /dev/null 2>&1; then
        echo "pure-pw doesn't exists, exiting...!"
        return 1;
    fi;
    #
    if [ -z "${1}" ];then
        echo "Usage ${FUNCNAME} [username] {real username} {real group} {home} {quota}!";
        return 2;
    fi;
    #
    USER="${1}";
    RUSER="dboxuser";
    RGROUP="dboxgroup";
    RHOME="/space/ftproot";
    UHOME="${RHOME}/${USER}";
    UQUOTA="-1";
    FPASS=$(apg -n1 -m8 -x8 -MCNL -t);
    PASS=$(echo ${FPASS} | cut -f1 -d' ');
    #
    if [ -n "${2}" ];then RUSER="${2}";fi
    if [ -n "${3}" ];then RGROUP="${3}";fi
    if [ -n "${4}" ];then UHOME="${4}";fi
    if [ -n "${5}" ];then UQUOTA="${5}";fi
    #
    echo "Creating FTP acoount ${USER}, password: ${FPASS} ... ";
    pure-pw useradd ${USER} -u ${RUSER} -g ${RGROUP} -d ${UHOME} -N ${UQUOTA};
    if [ "$?" -eq "0" ];then echo "done!"; else echo "fail!"; return 3;fi
    #
    echo -n "Regenerating FTP users databases ... ";
    pure-pw mkdb
    if [ "$?" -eq "0" ];then echo "done!"; else echo "fail!"; return 3;fi
    #
    echo "Listing createting user ....";
    pure-pw show ${USER}
    if [ "$?" -eq "0" ];then echo "done!"; else echo "fail!"; return 3;fi
    #
    echo -n "Preparing home directoey...";
    mkdir -p ${UHOME}
    chown -R ${RUSER}:${RGROUP} ${UHOME}
    touch ${UHOME}/${USER}.home
    echo "done!";

    echo -n "Testing user ... ";
    lftp ftp://${USER}:${PASS}@localhost -e "ls;quit" >/dev/null 2>&1;
    echo "done"
}
