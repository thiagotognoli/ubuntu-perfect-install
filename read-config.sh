#!/bin/bash

configDir=".config"

tmpDir="tmp"

log_file="$tmpDir/log.log"

mkdir -p "$tmpDir"

log() {
    echo "$1"
}

parseConfigs() {

    local _fileExtension _configDir _configCustomDir
    _fileExtension="${1}"; _configDir="${2}"; _configCustomDir="${3}";

    local sectionField sectionRegex sectionRegexValue
    sectionField="${4}"; sectionRegex="${5}"; sectionRegexValue="${6}"

    local _fields _fieldsDefaultValue _fieldsRequired _fieldsFilterValue
    _fields="${7}"
    _fieldsDefaultValue="${8}"
    _fieldsRequired="${9}"
    _fieldsFilterValue="${10}"

    local _sortConfigs
    _sortConfigs="${11}"

    local configs configsCustom
    configs="$(find $_configDir -name "*.$_fileExtension" -exec bash -c "cat {} && echo" \;)"
    configsCustom="$(find $_configCustomDir -name "*.$_fileExtension" -exec bash -c "cat {} && echo" \;)"
    configs="$(echo -e "$configs\n$configsCustom" | sed -r -e "s/(#.*)//" -e "/^[[:space:]]*$/d" -e "s/^([[:space:]]*)([^[[:space:]].*)/\2/")"
    configs="$(echo "$configs" | tac)"

    local -A sectionsProcessed
    local sections=()

    local fields=("$sectionField")
    eval "fields+=($_fields)"

    local fieldsRequired=("$sectionField")
    eval "fieldsRequired+=($_fieldsRequired)"

    local -A fieldsFilterValue
    eval "fieldsFilterValue+=($_fieldsFilterValue)"

    local -A fieldsDefaultValue
    eval "fieldsDefaultValue+=($_fieldsDefaultValue)"


    local sort=false
    local fieldsToSort=()
    local -A fieldsToSortTypes
    local -A fieldsToSortLenght

    local sortConfigs="$_sortConfigs"

    sortConfigs=(${sortConfigs//;/ })
    local sortConfigRegex="(.*)\:(.*)\,([0-9]*)"
    for sortConfig in "${sortConfigs[@]}";
    do
        if [[ $sortConfig =~ $sortConfigRegex ]]; then
            sort=true
            fieldsToSort+=("${BASH_REMATCH[1]}")
            fieldsToSortTypes["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
            fieldsToSortLenght["${BASH_REMATCH[1]}"]="${BASH_REMATCH[3]}"
        #else
        #   log "no match"
        fi
    done

    local -A fieldsRegex
    fieldsRegex["$sectionField"]="$sectionRegex"

    local -A fieldsValueRegex
    fieldsValueRegex["$sectionField"]="$sectionRegexValue"

    for field in "${fields[@]}"
    do
        #echo "preenchendo $field"
        if [ ! "${fieldsDefaultValue["$field"]+true}" ];
        then
            fieldsDefaultValue["$field"]=""
        fi
        if [ ! "${fieldsRegex["$field"]+true}" ];
        then
            #echo "preenchendo regex $field"
            fieldsRegex["$field"]="^$field\="
        fi
        if [ ! "${fieldsValueRegex["$field"]+true}" ];
        then
            fieldsValueRegex["$field"]="s/${fieldsRegex[$field]}(.*)/\1/"
        fi
    done

    local -A currentFieldsValues
    for fieldDefault in "${fields[@]}"
    do
        currentFieldsValues["$fieldDefault"]="${fieldsDefaultValue["$fieldDefault"]}"
    done

    declare -A fieldsValues
    local fieldsValuesOrders=()

    local line
    while read line; do
        local field=false
        for fieldRegex in "${fields[@]}"
        do
            local regex="${fieldsRegex[$fieldRegex]}"
            #echo "Regex: $regex"
            if [[ "$line" =~ $regex ]]; then
                field="$fieldRegex"
                break;
            fi;
        done

        if [ "$field" != "false" ]; then
            local value="$(sed -r "${fieldsValueRegex["$field"]}" <<< "$line" )"
            currentFieldsValues["$field"]="$(sed -r "${fieldsValueRegex["$field"]}" <<< "$line" )"
            #echo "preenchendo $field = ${currentFieldsValues["$field"]}"        

            if [ "$field" = "$sectionField" ]; then
                if [[ "${sectionsProcessed["$value"]}" != "true" ]];
                then            
                    #testar requiridos
                    local requiredTest=true
                    local fieldRequired

                    for fieldRequired in "${fieldsRequired[@]}";
                    do
                        if [ ! "${currentFieldsValues["$fieldRequired"]}" ]; then
                            requiredTest=false
                        fi;
                    done
                    #testar valores requiridos
                    for fieldRequired in "${!fieldsFilterValue[@]}";
                    do
                        if [[ "${currentFieldsValues["$fieldRequired"]}" != "${fieldsFilterValue["$fieldRequired"]}" ]]; then
                            requiredTest=false
                        fi;
                    done

                    #echo "---requiredTest: $requiredTest"
                    #imprmir
                    if [ "$requiredTest" = "true" ]; then
                        sections+=("$value")
                        for fieldValue in "${fields[@]}";
                        do
                            #echo "$fieldValue: ${currentFieldsValues["$fieldValue"]}"
                            fieldsValues["$value","$fieldValue"]="${currentFieldsValues["$fieldValue"]}"
                            fieldsValuesOrders+=("$value","$fieldValue")
                        done
                    fi
                fi
                sectionsProcessed["$value"]=true

                #limpar fields
                for fieldDefault in "${fields[@]}"
                do
                    currentFieldsValues["$fieldDefault"]="${fieldsDefaultValue["$fieldDefault"]}"
                done                
                
            fi            
        fi
    done <<< "$configs"


    if [[ "${sections[@]}" && "$sort" = "true" ]]; then
        local sectionsToOrderKey=()
        local -A sectionsOrderKey
        local orderKey=""

        for section in "${sections[@]}";
        do
            for fieldToSort in "${fieldsToSort[@]}";
            do
                local value="${fieldsValues["$section","$fieldToSort"]}"
                case "${fieldsToSortTypes["$fieldToSort"]}" in
                        "numeric")
                            value="$(printf "%0${fieldsToSortLenght["$fieldToSort"]}d" "$value")"
                                ;;
                        "string")
                            local fieldValueLenght=${#value}
                            local padLenght=${fieldsToSortLenght["$fieldToSort"]}
                            let padLenght=padLenght-fieldValueLenght
                            value="$(printf "%s%${padLenght}s" "$value")"
                                ;;
                esac
                orderKey+="$value|"
            done
            sectionsOrderKey["$orderKey"]="$section"
            sectionsToOrderKey+=("$orderKey")
            orderKey=""
        done

        sections=()
        local element
        while IFS= read -r -d '' element; do
            sections+=( "${sectionsOrderKey["$element"]}" )
        done < <(printf "%s\0" "${sectionsToOrderKey[@]}" | LC_ALL=C sort -z)
    fi

    for section in "${sections[@]}";
    do
        for field in "${fields[@]}";
        do
            sectionField="$section,$field"
            echo "$sectionField: ${fieldsValues["$sectionField"]}"
        done
    done

    #caso grupo nao exista crie ?
}


#group name order select disabled -.gsegroup


function parseGnomeShellExtensionGroups() {
    local _fileExtension _configDir _configCustomDir
    _fileExtension="gsegroup"
    _configDir="$configDir/default/gnome-shell-extension"
    _configCustomDir="$configDir/custom/gnome-shell-extension"

    local sectionField sectionRegex sectionRegexValue
    sectionField="name"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='"selected" "order" "disabled"'
    local _fieldsDefaultValue='["selected"]=false ["order"]=99999 ["disabled"]=false'

    local _fieldsRequired=''

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue='["disabled"]=false'
    #local _fieldsFilterValue=''

        
    local _sortConfigs="order:numeric,10;name:string,250"
    #local _sortConfigs=""

    parseConfigs \
        "$_fileExtension" \
        "$_configDir" \
        "$_configCustomDir" \
        "$sectionField" \
        "$sectionRegex" \
        "$sectionRegexValue" \
        "$_fields" \
        "$_fieldsDefaultValue" \
        "$_fieldsRequired" \
        "$_fieldsFilterValue" \
        "$_sortConfigs"
}


function parseGnomeShellExtensions() {
    local _fileExtension _configDir _configCustomDir
    _fileExtension="gsextension"
    _configDir="$configDir/default/gnome-shell-extension"
    _configCustomDir="$configDir/custom/gnome-shell-extension"

    local sectionField sectionRegex sectionRegexValue
    sectionField="code"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='"id" "name" "description" "url" "group" "selected" "order" "disabled"'
    local _fieldsDefaultValue='["group"]="General" ["selected"]=false ["order"]=99999 ["disabled"]=false'

    local _fieldsRequired='"id" "name"'

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue='["disabled"]=false'
    #local _fieldsFilterValue=''

        
    local _sortConfigs="order:numeric,10;name:string,250"
    #local _sortConfigs=""

    parseConfigs \
        "$_fileExtension" \
        "$_configDir" \
        "$_configCustomDir" \
        "$sectionField" \
        "$sectionRegex" \
        "$sectionRegexValue" \
        "$_fields" \
        "$_fieldsDefaultValue" \
        "$_fieldsRequired" \
        "$_fieldsFilterValue" \
        "$_sortConfigs"
}

echo "=========================="
echo "Groups"
parseGnomeShellExtensionGroups

echo "=========================="
echo "Extensions"
parseGnomeShellExtensions

exit


gnome_shell_extension.gsextension
#config file fields
# [code]
# id=<integer>
# name=<string>
# description=<string>
# url=<string>
# group=<string>
# selected=true|false
# disabled=true|false
