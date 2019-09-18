import socket
import sys
import os
from subprocess import call

BRIDGE = "br0" 
HOST = ''   # Symbolic name meaning all available interfaces
PORT = 8888 # Arbitrary non-privileged port
priority = 4
 
# Datagram (udp) socket
try :
	
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    print 'Socket created'
except socket.error, msg :
    print 'Failed to create socket. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
    sys.exit()
 
 
# Bind socket to local host and port
try:
    s.bind((HOST, PORT))
except socket.error , msg:
    print 'Bind failed. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
    sys.exit()
     
print 'Socket bind complete'

#now keep talking with the client
while 1:
    global priority
    # receive data from client (data, addr)
    d = s.recvfrom(1024)
    data = d[0]
    addr = d[1]
	
    address1,address2,empty = data.split("-")

    eid1,rloc1 = address1.split(",")
    eid2,rloc2 = address2.split(",")
    print("EID 1: " + eid1)
    print("RLOC 1: " + rloc1)   
    print("EID 2: " + eid2)
    print("RLOC 2: " + rloc2)
    
    priority += 1
           
    #EID1 to RLOC1     
    call(["ovs-ofctl", "add-flow", BRIDGE, "priority="+str(priority)+",in_port=1,dl_type=0x0800,nw_dst="+eid1+",action=set_field:"+rloc1+"->tun_dst,output:2"])  
			
    priority +=1
    #EID2 to RLOC2     
    call(["ovs-ofctl", "add-flow", BRIDGE, "priority="+str(priority)+",in_port=1,dl_type=0x0800,nw_dst="+eid2+",action=set_field:"+rloc2+"->tun_dst,output:2"]) 
	    
    #RLOC to EID
    #call(["ovs-ofctl", "add-flow", BRIDGE, "priority=6,in_port=2,dl_type=0x0800,nw_dst="+rloc+",action=set_field:"+eid+"->tun_dst,output:1"]) 
    print("\nInserite flow-rules per EID: %s  RLOC: %s  nel bridge: %s" % (eid1, rloc1, BRIDGE))
    print("Inserite flow-rules per EID: %s  RLOC: %s  nel bridge: %s" % (eid2, rloc2, BRIDGE))
	
    if not data: 
        break
	
    reply = 'fatto!....  ' + data
	
    
    s.sendto(reply , addr)

    print 'Message[' + addr[0] + ':' + str(addr[1]) + '] - ' + data.strip()
    data = []
s.close()
