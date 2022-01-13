function menu_alternative_terminals() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Terminator [apt]")
    options_selected+=(FALSE)
    options_id+=("addApt \"terminator\"")

    options_title+=("Terminology [snap edge classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapEdgeClassic \"terminology\"")

    options_title+=("Cool Retro Term [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"cool-retro-term\"")

    optionsLength=${#options_id[@]}
    optionsToShow=();
    for (( i=0; i<${optionsLength}; i++ ));
    do
        optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
    done

    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione os APPs para instalar" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
}