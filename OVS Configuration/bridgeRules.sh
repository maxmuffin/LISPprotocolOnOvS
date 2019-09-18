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

#Inoltro pacchetti lisp che arrivano dalla porta 2(lisp0) vengono inviati sulla porta 3 dell'lxc dove è presente il lisp cp
	ovs-ofctl add-flow $BRIDGE priority=4,in_port=2,dl_type=0x0800,nw_proto=17,tp_dst=4342,action=mod_dl_dst:$LXC_MAC,output:3
	#ovs-ofctl add-flow $BRIDGE priority=4,tun_id=0x000001,in_port=2,action=mod_dl_dst:$LXC_MAC,output:3

#(decapsulamento)su ogni pacchetto in ingresso in lisp0 viene modificatoil mac_address con quello dell'host EID di destinazione e inoltrato a vport_host
ovs-ofctl add-flow $BRIDGE priority=3,in_port=2,actions=mod_dl_dst:$HOST_MAC,output:1


#forwarding del protocollo ARP(EtherType 0x0806) senza alcuna modifica dei pacchetti
ovs-ofctl add-flow $BRIDGE priority=2,in_port=1,dl_type=0x0806,actions=NORMAL


#(incapsulamento) su tutti pacchetti IP(Ethertype 0x0800) in ingresso da wlp3s0 destinati a HOST2 viene settato l'RLOC di destinazione e forwardati sulla porta lisp0
#ovs-ofctl add-flow $BRIDGE 'priority=1,in_port=1,dl_type=0x0800,nw_dst=$IP_HOST2,action=set_field:$RLOC_DST->tun_dst,output:2'
ovs-ofctl add-flow $BRIDGE 'priority=1,in_port=1,dl_type=0x0800,nw_dst=12.0.0.2,action=set_field:153.100.122.1->tun_dst,output:2'
#ovs-ofctl add-flow br0 priority=1,in_port=1,dl_type=0x0800,nw_dst=12.0.0.2,actions=mod_nw_dst:153.100.122.1->tun_dst,output:2
#ovs-ofctl add-flow br0 priority=1,in_port=1,dl_type=0x0800,nw_dst=12.0.0.2,actions=mod_nw_dst:153.100.122.1,output:2


#flusso a bassa priorità comunicazione L2/L3 di tutti i pacchetti non specificati
ovs-ofctl add-flow $BRIDGE 'priority=0, actions=NORMAL'

