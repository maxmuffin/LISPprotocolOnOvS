#!/bin/bash

BRIDGE="br0"
PORTA_HOST="vport_host"
PORTA_LXC="lxc0" 
PORTA_LISP="lisp0"

ovs-vsctl del-port $BRIDGE $PORTA_HOST
ovs-vsctl del-port $BRIDGE $PORTA_LXC
ovs-vsctl del-port $BRIDGE $PORTA_LISP
ovs-vsctl del-controller $BRIDGE
ovs-vsctl del-br $BRIDGE
ifconfig $PORTA_HOST down
ifconfig $PORTA_LXC down
ifconfig $PORTA_LISP down

