function ls-wp () {
    if [[ -d "${1}" ]];then
        for d in $(ls "${1}");do 
            if [[ -f "${1}/${d}/wp-config.php" ]];then
		echo "${d}";
	    fi;
	done;
    else
        echo "Usage ${FUNCNAME[0]} [directory]!";
    fi;
}
