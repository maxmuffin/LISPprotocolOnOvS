#!/bin/bash

INTERFACCIA_INTERNET="wlp3s0"

BRIDGE="br0"
BRIDGE_ADDRESS="192.168.1.102/24"

PORTA_HOST="vport_host"
HOST_ADDRESS="11.0.0.1/24"
HOST_MAC="08:00:27:CB:7E:65"

PORTA_LISP="lisp0"
RLOC_DST="153.100.122.1"
IP_HOST2="12.0.0.2"

PORTA_LXC="lxc0" 
LXC_ADDRESS="10.0.3.127"
LXC_MAC="00:16:3e:9b:44:c3"

# creo il bridge e gli imposto un indirizzo

	ovs-vsctl --may-exist add-br $BRIDGE -- set bridge $BRIDGE datapath_type=netdev
	ifconfig $BRIDGE $BRIDGE_ADDRESS up 

#creo una porta virtuale per l'host e gli assegno un indirizzo

	ip tuntap add mode tap $PORTA_HOST
	ifconfig $PORTA_HOST $HOST_ADDRESS up
		

#aggiungo le porte al bridge, setto le interfacce ed aggiungo internet (wlp3s0)
ovs-vsctl --may-exist add-port $BRIDGE $INTERFACCIA_INTERNET

ovs-vsctl --may-exist add-port $BRIDGE $PORTA_HOST 
ovs-vsctl set interface $PORTA_HOST ofport_request=1 

ovs-vsctl --may-exist add-port $BRIDGE $PORTA_LISP 
ovs-vsctl set interface $PORTA_LISP ofport_request=2 type=lisp options:remote_ip=flow options:key=flow

ovs-vsctl --may-exist add-port $BRIDGE $PORTA_LXC
ovs-vsctl set interface $PORTA_LXC ofport_request=3











