function svn-wp-stat () {
    if [ "${1}" ];then
        wd="${1}";
    else
        wd="/var/www";
    fi
    echo "Checking SVN WordPress status for sites in \"${wd}\" directory ...";
    for v in $(ls-wp "${wd}");do
        echo "#### ******* /var/www/${v} *********";
        svn st "${wd}/${v}";
    done;
}
