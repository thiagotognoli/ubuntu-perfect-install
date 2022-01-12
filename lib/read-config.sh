configDir="$basePath/.config"
tmpDir="$basePath/tmp"
configDirSubPathDefault="default"
configDirSubPathCustom="custom"


log() {
    echo "$1"
}

logDebug() {
    #echo -ne "$1"
    echo ""
    #"$1"
}

loadCommands() {
    local _fileExtension="commands"
    local commands="$(find $configDir/$configDirSubPathDefault -name "*.$_fileExtension")"
    local commandsCustom="$(find $configDir/$configDirSubPathCustom -name "*.$_fileExtension")"
    local command
    for command in "${commands[@]}";
    do
        source "$command"
    done
    for command in "${commandsCustom[@]}";
    do
        source "$command"
    done
}
parseConfigs() {

    local _fileExtension="${1}";
    local _configDir="${2}";
    local _configCustomDir="${3}";

    local sectionField="${4}";
    local sectionRegex="${5}";
    local sectionRegexValue="${6}"

    local _fields="${7}"
    local _fieldsDefaultValue="${8}"
    local _fieldsRequired="${9}"
    local _fieldsFilterValue="${10}"

    local _sortConfigs="${11}"

    local _outputString="${12}"

    local _customFields="${13}"

    local IFS

    local configs="$(find $_configDir -name "*.$_fileExtension" -exec bash -c "cat {} && echo" \;)"
    local configsCustom="$(find $_configCustomDir -name "*.$_fileExtension" -exec bash -c "cat {} && echo" \;)"
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
    local sortConfig 

    IFS=" "
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

    local field
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
    local fieldDefault
    for fieldDefault in "${fields[@]}"
    do
        currentFieldsValues["$fieldDefault"]="${fieldsDefaultValue["$fieldDefault"]}"
    done

    local -A fieldsValues
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

        local section
        for section in "${sections[@]}";
        do
            local orderKey=""
            local fieldToSort
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
        done

        sections=()
        local element
        IFS= 
        while read -r -d '' element; do
            sections+=( "${sectionsOrderKey["$element"]}" )
        done < <(printf "%s\0" "${sectionsToOrderKey[@]}" | LC_ALL=C sort -z)
    fi

    local section
    for section in "${sections[@]}";
    do
        local _tField
        for _tField in "${fields[@]}";
        do
            local _sectionField="$section,$field"
            echo "local $_tField=\"${fieldsValues["$_sectionField"]}\"" >> fin.log
            eval "local $_tField=\"${fieldsValues["$_sectionField"]}\""
        done
        eval "$_customFields"
        eval "echo -ne \"$_outputString\""
    done

}


function parseAppsGroups() {
    local _commandGroup="$1" 

    local _fileExtension _configDir _configCustomDir
    _fileExtension="group"
    _configDir="$configDir/$configDirSubPathDefault/apps"
    _configCustomDir="$configDir/$configDirSubPathCustom/apps"

    local sectionField sectionRegex sectionRegexValue
    sectionField="name"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='"selected" "order" "disabled" "command"'
    local _fieldsDefaultValue='[selected]=FALSE [order]=99999 [disabled]=FALSE'

    local _fieldsRequired=''

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue='[disabled]=FALSE'
    #local _fieldsFilterValue=''

        
    local _sortConfigs="order:numeric,10;name:string,250"
    #local _sortConfigs=""

    #local _outputString="$1"
    local _outputString='options_title+=(\"$name\"); options_selected+=($selected); options_id+=(\""$command\"");\n'

    #local _customProcessValue='command="'$1' \\\"$name\\\"";'
    local _customProcessValue='[[ "$command" ]] && command="$command" || command="'"$1"'";'


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
        "$_sortConfigs" \
        "$_outputString" \
        "$_customProcessValue"
}


function parseApps() {
    local _filterGroup="$1"

    local _fileExtension _configDir _configCustomDir
    _fileExtension="apps"
    _configDir="$configDir/$configDirSubPathDefault/apps"
    _configCustomDir="$configDir/$configDirSubPathCustom/apps"

    local sectionField sectionRegex sectionRegexValue
    sectionField="code"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='id name description group selected command order disabled'
    local _fieldsDefaultValue='[group]=General [selected]=FALSE [order]=99999 [disabled]=FALSE'

    local _fieldsRequired='id name'

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue="[disabled]=FALSE [group]=\"$_filterGroup\""
    #local _fieldsFilterValue=''

        
    #local _sortConfigs="order:numeric,10;name:string,250"
    local _sortConfigs="order:numeric,10;name:string,250"

    #local _sortConfigs=""

    #local _outputString="Id: \$id\nName: \$name\nSelected: \$selected\n"
    local _outputString='options_title+=(\"$name\"); options_selected+=($selected); options_id+=(\""$command\"");\n'

    local _customProcessValue='[[ "$command" ]] || command="echo \\"Nada a fazer em $name\\"";'

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
        "$_sortConfigs" \
        "$_outputString" \
        "$_customProcessValue"
}


function parseGnomeShellExtensionGroups() {
    local _fileExtension _configDir _configCustomDir
    _fileExtension="gsegroup"
    _configDir="$configDir/$configDirSubPathDefault/gnome-shell-extension"
    _configCustomDir="$configDir/$configDirSubPathCustom/gnome-shell-extension"

    local sectionField sectionRegex sectionRegexValue
    sectionField="name"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='"selected" "order" "disabled"'
    local _fieldsDefaultValue='["selected"]=FALSE ["order"]=99999 ["disabled"]=FALSE'

    local _fieldsRequired=''

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue='["disabled"]=FALSE'
    #local _fieldsFilterValue=''

        
    local _sortConfigs="order:numeric,10;name:string,250"
    #local _sortConfigs=""

    #local _outputString="$1"
    local _outputString='options_title+=(\"$name\"); options_selected+=($selected); options_id+=(\""$command\"");\n'

    local _customProcessValue='command="menu_gnomeshellextensions \\\"$name\\\"";'

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
        "$_sortConfigs" \
        "$_outputString" \
        "$_customProcessValue"
}

function parseGnomeShellExtensions() {
    local _filterGroup="$1"

    local _fileExtension _configDir _configCustomDir
    _fileExtension="gsextension"
    _configDir="$configDir/$configDirSubPathDefault/gnome-shell-extension"
    _configCustomDir="$configDir/$configDirSubPathCustom/gnome-shell-extension"

    local sectionField sectionRegex sectionRegexValue
    sectionField="code"
    sectionRegex="^\[.*\]"
    sectionRegexValue="s/^\[([^\[]*)\]/\1/"

    local _fields='"id" "name" "description" "url" "group" "selected" "custom_command" "order" "disabled"'
    local _fieldsDefaultValue='["group"]="General" ["selected"]=FALSE ["order"]=99999 ["disabled"]=FALSE'

    local _fieldsRequired='"id" "name"'

    #local _fieldsFilterValue='["disabled"]=false ["group"]="General"'
    local _fieldsFilterValue="[\"disabled\"]=FALSE [\"group\"]=\"$_filterGroup\""
    #local _fieldsFilterValue=''

        
    local _sortConfigs="order:numeric,10;name:string,250"
    #local _sortConfigs=""

    #local _outputString="Id: \$id\nName: \$name\nSelected: \$selected\n"
    local _outputString='options_title+=(\"$name\"); options_selected+=($selected); options_id+=(\""$command\"");\n'

    local _customProcessValue='[[ "$custom_command" ]] && command="$custom_command" || command="addGnomeShellExtension \\\"$id\\\"";'

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
        "$_sortConfigs" \
        "$_outputString" \
        "$_customProcessValue"
}

# while [ "$1" != "" ]; do
#     case $1 in
#         -e | --extensions )     shift
#                                 filterGroup="$1"
#                                 parseGnomeShellExtensions "$filterGroup"
#                                 exit
#                                 ;;
#         -g | --groups )         parseGnomeShellExtensionGroups
#                                 exit
#                                 ;;
#         # -h | --help )           usage
#         #                         exit
#         #                         ;;
#         # * )                     usage
#         #                         exit 1
#     esac
#     shift
# done
function read_appsGroups () {
    callFunction="$1"
    parseAppsGroups "$callFunction"
}

function read_apps () {
    filterGroup="$1"
    parseApps "$filterGroup"
}


function read_gnomeShellExtensionGroups () {
    parseGnomeShellExtensionGroups
}

function read_gnomeShellExtensions() {
    filterGroup="$1"
    parseGnomeShellExtensions "$filterGroup"
}
#exit


#gnome_shell_extension.gsextension
#config file fields
# [code]
# id=<integer>
# name=<string>
# description=<string>
# url=<string>
# group=<string>
# selected=true|false
# disabled=true|false
