#!/bin/bash

#todo -users tzord and use /home/tzord/.Xautority case exist
#todo script to setup certificate
#-sslGenCa -sslGenCert
#caso noa exista arquivos gerar, e configurar parametros pra usar
#todo srandr resolvution fix
trap "echo Exited!; exit;" SIGINT SIGTERM

port=5900
password_file="/root/.vncpasswd"
#first_run=true
echo "Iniciando"

if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
	echo "Port $port in use";
	exit -1;
fi

export DISPLAY=:0

dpName="VIRTUAL1"

sddmSession="$(ls /var/run/sddm/ | head -1)"
export XAUTHORITY="/var/run/sddm/$sddmSession"

newMode="$(gtf 1920 1080 60 | grep Modeline | sed -r "s/(Modeline )(.*)/\2/")"
newModeName="$(echo $newMode | sed -r "s/(\")([^\"]*)(\")(.*)/\2/")"
newModeMode="$(echo $newMode | sed -r "s/(\")([^\"]*)(\" )(.*)/\4/")"

#xrandr --newmode $newModeName $newModeMode
#xrandr --addmode $dpName $newModeName
#xrandr --output $dpName --mode $newModeName
##xrandr --output DP1 --mode 1920x1080 --crtc 1

while true;
do
	sddmSession="$(ls /var/run/sddm/ | head -1)"

	export XAUTHORITY="/var/run/sddm/$sddmSession"

	echo "sddmSession $sddmSession"
	#/usr/bin/x11vnc -forever -noxdamage -rfbauth /root/.vncpasswd -rfbport 5900 -shared -o /var/log/x11vnc.log -env FD_XDM=1 -display :0 -auth /var/run/sddm/"$sddmSession"
	/usr/bin/x11vnc -env FD_XDM=1 -display :0 -forever -rfbauth "$password_file" -rfbport $port -auth /var/run/sddm/"$sddmSession" -shared -noxdamage -geometry 1536x864 -o /var/log/x11vnc.log
	if [ $? -eq 0 ]; then
  		echo "Finlazindo"
	else
		echo "Erro"
		#if [ "$first_run" = "true" ]; then
		#	exit -1
		#	break
		#fi
	fi
	#first_run=false
don