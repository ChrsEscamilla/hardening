#!/bin/bash
echo "script by Christopher_Escamilla"



SISTEMA=$(cat /etc/os-release awk -F = ‘/^ NAME/{print $ 2}’/etc/os-release)
echo "tu sistema operatico es $SISTEMA"
sleep 3
clear


echo "Comprobando clamav"
rpm -q clamav
if  yum -q list installed *clamav*; then
        echo "Se reemplazará la version de clamav prseguridad"
        sleep 3
        sudo systemctl stop clamd@scan && sudo systemctl disable clamd@scan
        sudo systemctl status clamd@scan
        sudo freshclam
        sudo systemctl enable clamd@scan
        sudo systemctl start clamd@scan
        sudo systemctl status clamd@scan
        echo "Se reemplazó la versión con éxito"
else
        echo "Se instalará clamav por su seguridad"
        sleep 3
        sudo yum -y install epel-release
        sudo yum clean all
        sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
        sudo freshclam
        sudo setsebool -P antivirus_can_scan_system 1
        sudo setsebool -P clamd_use_jit 0
        sudo systemctl enable clamd@scan
        sudo systemctl start clamd@scan
        sudo yum remove epel-release
        sudo yum update
        echo "Se instalo correctamente"
fi
clear

if [[ $CENTOS = *7* ]]; then

    echo "Instalaremos EPEL en tu sistema CentOS 7"
    sleep 3
    sudo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo rpm -ivh epel-release-latest-7.noarch.rpm
    echo "Verificaremos tu lista de repositorios"
    sudo yum -y repolist
fi


echo "Se verificarán las actualizaciones"
sleep 3
sudo yum list updates

echo "Se realizarán las actulizaciones correspondientes"
sleep 3
sudo yum -y update
echo "FAVOR DE REINICIAR EL SISTEMA"

echo "FIN DEL PROGRAMA"
clear