#!/bin/bash

#------------------------------------------------------------------------------
# parse the ini like $0.$host_name.cnf and set the variables
# cleans the unneeded during after run-time stuff. Note the MainSection
# courtesy of : http://mark.aufflick.com/blog/2007/11/08/parsing-ini-files-with-sed
#------------------------------------------------------------------------------
doParseConfFile(){
    # set a default cnfiguration file
    cnf_file="$run_unit_bash_dir/$run_unit.cnf"

    # however if there is a host dependant cnf file override it
    test -f "$run_unit_bash_dir/$run_unit.$host_name.cnf" \
    && cnf_file="$run_unit_bash_dir/$run_unit.$host_name.cnf"

    # yet finally override if passed as argument to this function
    # if the the ini file is not passed define the default host independant ini file
    test -z "$1" || cnf_file=$1;shift 1;


    test -z "$2" || ini_section=$2;shift 1;
    doLog "DEBUG read configuration file : $cnf_file"
    doLog "INFO read [$ini_section] section from config file"

    # debug echo "@doParseConfFile cnf_file:: $cnf_file"
    # coud be later on parametrized ...
    test -z "$ini_section" && ini_section='MAIN_SETTINGS'

    doLog "DEBUG reading: the following configuration file"
    doLog "DEBUG ""$cnf_file"
    ( set -o posix ; set ) | sort >"$tmp_dir/vars.before"

    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/#.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
        < $cnf_file \
        | sed -n -e "/^\[$ini_section\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`

    ( set -o posix ; set ) | sort >"$tmp_dir/vars.after"

    doLog "INFO added the following vars from section: [$ini_section]"
    cmd="$(comm -3 $tmp_dir/vars.before $tmp_dir/vars.after | perl -ne 's#\s+##g;print "\n $_ "' )"
    echo -e "$cmd"
    echo -e "$cmd" >> $log_file
    echo -e "\n\n"
    sleep 1; printf "\033[2J";printf "\033[0;0H" # and clear the screen
}
#eof func doParseConfFile
