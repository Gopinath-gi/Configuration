#!/bin/bash
APTSOURCELIST=/etc/apt/sources.list
NETWORKCONF=/etc/NetworkManager/NetworkManager.conf
#Corrige BUG NETWORKCONG
function evalua(){
VARTEST=`cat /etc/NetworkManager/NetworkManager.conf | grep -i managed | awk -F '=' '{print $2}'`
        if [ $VARTEST == "false" ]; then
                sed -i -e "/managed/s/false/true/" $NETWORKCONF
                shutdown -r now
        else
                configure
        fi
}
function configure(){
        sed -i -E "/(deb-src|^#|^$)/d" $APTSOURCELIST
        apt-get -y --force-yes update && apt-get -y --force-yes upgrade
        apt-get -y --force-yes install vim htop ubuntu-restricted-extras rar unace p7zip-full p7zip-rar sharutils mpack lha arj ssh
}
