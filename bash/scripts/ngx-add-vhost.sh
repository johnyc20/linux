#!/bin/bash
#===============================================================================
#
#          FILE:  ngx-add-vhost.sh
# 
#         USAGE:  ./ngx-add-vhost.sh 
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
#       CREATED:  01/10/2016 06:22:33 PM EET
#      REVISION:  ---
#===============================================================================


## vhosts files and templates
#dst='';
src='template.tld';
webmu="www-data"
webmg="developers"

# load host specific variables
source /etc/scrips.defs

# Nginx
NWD="/etc/nginx";
SA="sites-available";
NSA="${NWD}/${SA}"
SE="sites-enabled";
NSE="${NWD}/${SE}"
# PHP-FPM
PF="/etc/php-fpm.d"
NPPF="/etc/php-fpm.d/next_port"

function quit {
    echo "Usage ${0} dst_host_name new_ip_address {src_vhost_name}!"
    echo "Default src is ${NSA}/${src}.conf"
    exit 1;
    }

if [[ -n ${1} ]];then
    dst="${1}"
    if [[ -n ${2} ]];then
        nip="${2}";
    else
        quit
    fi;
    if [[ -n ${3} ]];then
        src="${3}";
    fi;
else
    quit
fi;


echo "Testing if template exists: ${NSA}/${src}.conf"
if [[ -f ${NSA}/${src}.conf ]];then 
    echo "Duplicating VHost...";
    cp ${NSA}/${src}.conf ${NSA}/${dst}.conf;
    sed -i "s/${src}/${dst}/g" ${NSA}/${dst}.conf

    echo "Changing IP of VHOST to: ${nip}...";
    if [[ -n ${nip} ]];then
        oip=$(cat ${NSA}/${src}.conf | grep listen | grep 80 | awk '{print $2}' | cut -f1 -d":");
        sed -i "s/${oip}/${nip}/g" ${NSA}/${dst}.conf
    fi;

    echo "Duplicating Php-Fpm entry..."
    if [[ -f ${PF}/${src}.conf ]];then
        cp ${PF}/${src}.conf ${PF}/${dst}.conf;
        sed -i "s/${src}/${dst}/g" ${PF}/${dst}.conf
        if [[ -f ${NPPF} ]];then
            np=$(cat ${NPPF});
            op=$(cat ${PF}/${src}.conf | grep '127.0.0.1:' | awk '{print $3}' | cut -f2 -d":");
            echo "Replacing port ${op} to ${np} on ${PF}/${dst}.conf and ${NSA}/${dst}.conf";
            sed -i "s/${op}/${np}/g" ${PF}/${dst}.conf;
            sed -i "s/${op}/${np}/g" ${NSA}/${dst}.conf;
            echo $[$(cat ${NPPF}) + 1] > ${NPPF};
        fi;
        echo "Testing php-fpm config and reloading it.."
        if php-fpm -t;then
            systemctl restart php-fpm.service
        fi;
    fi

    echo "Testing nginx config and reloading it..."
    ln -s ../${SA}/${dst}.conf ${NSE}
    if nginx -t > /dev/null;then
        nginx -s reload;
    fi;
    echo "Creating DR, if it not exists..."
    if [[ ! -d /var/www/${dst} ]]; then
        mkdir /var/www/${dst};
        chmod 2775 /var/www/
        chown -R ${webmu}:${webmg} /var/www/${dst}
        echo ${dst} >> /var/www/${dst}/index.html;
   fi;
fi;
