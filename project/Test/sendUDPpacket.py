from scapy.all import *

command = IP(dst="10.0.3.127")/fuzz(UDP(dport=4342))
send(command,loop=1)
