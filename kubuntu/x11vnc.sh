#!/bin/bash

echo "Iniciando"
while true;
do
	sddmSession="$(ls /var/run/sddm/ | head -1)"
	echo "sddmSession $sddmSession"
	#/usr/bin/x11vnc -forever -noxdamage -rfbauth /root/.vncpasswd -rfbport 5900 -shared -o /var/log/x11vnc.log -env FD_XDM=1 -display :0 -auth /var/run/sddm/"$sddmSession"
	/usr/bin/x11vnc -env FD_XDM=1 -display :0 -forever -rfbauth /root/.vncpasswd -rfbport 5900 -auth /var/run/sddm/"$sddmSession" -shared -noxdamage -o /var/log/x11vnc.log
	if [ $? -eq 0 ]; then
  		echo "Finlazindo"
	else
		echo "Erro"
		exit -1
		break
	fi
done
