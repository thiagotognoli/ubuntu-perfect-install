#!/bin/bash


trap "echo Exited!; exit;" SIGINT SIGTERM

port=5900
password_file="/root/.vncpasswd"
#first_run=true
echo "Iniciando"

if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        echo "Port $port in use";
        exit -1;
fi
while true;
do
        sddmSession="$(ls /var/run/sddm/ | head -1)"
        echo "sddmSession $sddmSession"
        #/usr/bin/x11vnc -forever -noxdamage -rfbauth /root/.vncpasswd -rfbport 5900 -shared -o /var/log/x11vnc.log -env FD_XDM=1 -display :0 -auth /var/run/sddm/"$sddmSession"
        /usr/bin/x11vnc -env FD_XDM=1 -display :0 -forever -rfbauth "$password_file" -rfbport $port -auth /var/run/sddm/"$sddmSession" -shared -noxdamage -o /var/log/x11vnc.log
        if [ $? -eq 0 ]; then
                echo "Finlazindo"
        else
                echo "Erro"
                #if [ "$first_run" = "true" ]; then
                #       exit -1
                #       break
                #fi
        fi
        #first_run=false
done
