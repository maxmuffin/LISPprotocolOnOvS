#!/bin/bash

# start ovsdb-server (configuration database)
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --private-key=db:Open_vSwitch,SSL,private_key --certificate=db:Open_vSwitch,SSL,certificate --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert --pidfile --detach

#initialize the database (only the first time)
ovs-vsctl --no-wait init

#start the main Open vSwitch daemon
ovs-vswitchd --pidfile --detach


