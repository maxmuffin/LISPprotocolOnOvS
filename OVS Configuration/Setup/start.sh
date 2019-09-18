#!/bin/bash

BGreen='\033[1;32m' 
reset=`tput sgr0`


#avvio il server

	sh /home/massi/Scrivania/OVS\ Configuration/start-server.sh

#Avvio LXC OpenLISPcp

	lxc-start -n OpenLISPcp

#Configuro il Br0

	sh /home/massi/Scrivania/OVS\ Configuration/set_br0.sh

#Aggiungo le regole nel bridge

	sh /home/massi/Scrivania/OVS\ Configuration/bridgeRules.sh

#Lancio il server per LXC

echo "${BGreen}
*** Startup COMPLETE ***${reset}"


	python /home/massi/Scrivania/project/server.py

