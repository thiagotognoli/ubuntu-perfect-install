#!/bin/bash

configDir=".config"
tmpDir="tmp"

log_file="$tmpDir/log.log"

mkdir -p "$tmpDir"

log() {
    echo "$1"
}

parseGnomeShellExtensions() {
    gnomeShellExtensionCondigDir="$1"
    
    configs="$(find $gnomeShellExtensionCondigDir -name "*.cnf" -exec bash -c "cat {} && echo" \;)"
    configs="$(echo "$configs" | sed -r -e "s/(#.*)//" -e "/^[[:space:]]*$/d" -e "s/^([[:space:]]*)([^[[:space:]].*)/\2/")"

    # [code]
    # id
    # name
    # description
    # url
    # group
    # selected

    code=""
    id=""
    name=""
    description=""
    url=""
    group="Geral"
    selected=false

    regexCode="^\[.*\]"
    regexId="^id\="
    regexName="^name\="
    regexDescription="^description\="
    regexUrl="^url\="
    regexGroup="^group\="
    regexSelected="^selected\="

    while read line; do
        if [[ "$line" =~ $regexCode ]]; then
            if [[ "$code" && "$id" && "$name" ]]; then
               echo "code: $code"
               echo "id: $id"
               echo "name: $name"
               echo "descritpion: $descritpion"
               echo "url: $url"
               echo "group: $group"
               echo "selected: $selected"
            fi
        code="$(echo "$line" | sed -r "s/^\[([^\[]*)\]/\1/" )"
        id=""
        name=""
        description=""
        url=""
        group="Geral"
        selected=false

        elif [[ "$line" =~ $regexId ]]; then
            id="$(echo "$line" | sed -r "s/$regexId(.*)/\1/")"
        elif [[ "$line" =~ $regexName ]]; then
            name="$(echo "$line" | sed -r "s/$regexName(.*)/\1/")"
        elif [[ "$line" =~ $regexDescription ]]; then
            description="$(echo "$line" | sed -r "s/$regexDescription(.*)/\1/")"
        elif [[ "$line" =~ $regexUrl ]]; then
            url="$(echo "$line" | sed -r "s/$regexUrl(.*)/\1/")"
        elif [[ "$line" =~ $regexGroup ]]; then
            group="$(echo "$line" | sed -r "s/$regexGroup(.*)/\1/")"
        elif [[ "$line" =~ $regexSelected ]]; then
            selected="$(echo "$line" | sed -r "s/$regexSelected(.*)/\1/")"
        else
            echo "Unknown config: $line"
        fi
    done <<< "$configs"

    if [[ "$code" && "$id" && "$name" ]]; then
        echo "code: $code"
        echo "id: $id"
        echo "name: $name"
        echo "descritpion: $descritpion"
        echo "url: $url"
        echo "group: $group"
        echo "selected: $selected"
    fi


}


_parseGnomeShellExtensions() {
    gnomeShellExtensionCondigDir="$configDir/gnome-shell-extension"
    # set a default cnfiguration file
    cnf_file="$gnomeShellExtensionCondigDir/teste.cnf"

    # however if there is a host dependant cnf file override it
    test -f "$gnomeShellExtensionCondigDir/teste.cnf" \
        && cnf_file="$gnomeShellExtensionCondigDir/teste.cnf"

    ## yet finally override if passed as argument to this function
    ## if the the ini file is not passed define the default host independant ini file
    #test -z "$1" || cnf_file=$1; shift 1;


    test -z "$2" || ini_section=$2; shift 1;
    log "DEBUG read configuration file : $cnf_file"
    log "INFO read [$ini_section] section from config file"

    # debug echo "@doParseConfFile cnf_file:: $cnf_file"
    # coud be later on parametrized ...
    test -z "$ini_section" && ini_section='MAIN_SETTINGS'

    log "DEBUG reading: the following configuration file"
    log "DEBUG ""$cnf_file"
    ( set -o posix ; set ) | sort >"$tmpDir/vars.before"

    configs="$(sed -r "s/(#.*)//" "$currentHomeDir/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')"


    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/#.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
        < $cnf_file \
        | sed -n -e "/^\[$ini_section\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`

    ( set -o posix ; set ) | sort >"$tmpDir/vars.after"

    log "INFO added the following vars from section: [$ini_section]"
    cmd="$(comm -3 $tmpDir/vars.before $tmpDir/vars.after | perl -ne 's#\s+##g;print "\n $_ "' )"
    echo -e "$cmd"
    echo -e "$cmd" >> $log_file
    echo -e "\n\n"
    #sleep 1; printf "\033[2J";printf "\033[0;0H" # and clear the screen

}

parseGnomeShellExtensions "$configDir/gnome-shell-extension"

exit

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
