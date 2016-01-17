#!/bin/bash
#===============================================================================
#
#          FILE:  ssl-gen-cert.sh
# 
#         USAGE:  ./ssl-gen-cert.sh 
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
#       CREATED:  01/16/2016 09:38:54 PM EET
#      REVISION:  ---
#===============================================================================

function ssl-gen-cert () {
    WD="/etc/nginx/ssl";
    KEYLEN="2048";
    # check for working directory
    if [ ! -d "${WD}" ];then
        echo "Working directory(${WD}) doesn't exists, please create it...";
        return 1;
    fi 
    # check for 'openssl' binary
    if ! openssl version > /dev/null 2>&1;then
        echo "Can't find 'openssl' on the PATH, please install it..."
        return 2;
    fi
    # generating keys/certificates
    if [[ -n "${1}" ]];then
        echo "**Generation passphrase..."
        apg -n1 -m8 -x8 -t

        echo "**Genrating ssl key ..."
        openssl genrsa -des3 -out ${WD}/${1}.key 512

        echo "**Generating certificate request... " 
        openssl req -new -key ${WD}/${1}.key -out ${WD}/${1}.csr

        echo "**Generating certificate file... ";
        openssl x509 -req -days 365 -in ${WD}/${1}.csr -signkey ${WD}/${1}.key -out ${WD}/${1}.crt

        echo "**Removing passphrase from ssl key file... "
        openssl rsa -in ${WD}/${1}.key -out ${WD}/${1}.pem

        #
        echo "**Disaplaying generated gertificate..."
        openssl x509 -in ${WD}/${1}.crt -text -noout
    
        #openssl req -in ${WD}/${1}.csr -text -noout
        #openssl rsa -in ${WD}/${1}.pem -text -noout
    else
        echo "Usage ${FUNCNAME} [hostname]!";
    fi;
}
