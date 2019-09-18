# LISPprotocolOnOvS
Implementation for adapt LISP protocol on Software Defined Network (SDN) using OvS and LXC 

Schema of created network:
<div style="text-align:center">
  <img src="https://github.com/maxmuffin/LISPprotocolOnOvS/blob/master/schema/schema_tesi.jpg" width="600">
</div>

## Install

1. Install OpenVSwitch on pc
2. Setup Virtual Machine
3. Install LXC on pc
4. Install OpenLisp Control Plane on LXC (tested on Ubuntu 14.04)
5. Put client.py on pc and server.py on LXC
6. See configuration files for setup bridge and tables
