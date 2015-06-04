#!/bin/bash
source colors.sh
echo -e $bldwht
read -p "This will install dnsmasq to manage your TLD (Top Level Domain). Do you still want to get it?(y/n)" -r
echo -e $txtrst
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo apt-get install dnsmasq
    echo;echo -e $bldwht"Enter vagrant ip (default parrot IP is 192.168.50.4):"$txtrst
    read ip
    echo -e $txtblu"local=/loc/\naddress=/loc/$ip"$txtrst | sudo tee /etc/dnsmasq.d/adapt-local
    echo -e 
    echo -e "You can found this config on $undwht/etc/dnsmasq.d/adapt-local$txtrst file"
    sudo service dnsmasq restart
fi
echo -e $txtgrn DONE $txtrst