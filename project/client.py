import socket   #for sockets
import sys  #for exit
import threading
from xml.dom import minidom



SERVER = "10.0.3.127"   # Symbolic name, meaning all available interfaces
SERVER_PORT = 4342 # Arbitrary non-privileged port

host_address = '192.168.1.102';
port_host = 8888;
OP = 1
i=0
tmp_address1 = ''
tmp_address2 = ''

def wait ():
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        print 'Socket created'
        #Bind socket to local host and port
        try:
                s.bind((SERVER, SERVER_PORT))
        except socket.error as msg:
                print 'Bind failed. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
                sys.exit()
        print 'Socket bind complete'
        #Start listening on socket

        print 'Socket now listening'
        global i
        #now keep talking with the client
        while True:
                #wait to accept a connection - blocking call
                data, addr = s.recvfrom(1024)
                if i==0:
                        print '\nINIZIALIZZO\n'
                        timer()
                        i+=1
        s.close()

def parse():
        # create dgram udp socket
        try:
                c = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        except socket.error:
                print 'Failed to create socket'
                sys.exit()

        #msg = raw_input('Enter message to send : ')
        address=[]
        global OP, tmp_address1, tmp_address2
        print ("\n***** OPERAZIONE numero: %d *****\n" % OP)
        OP +=1
        doc = minidom.parse("/home/admin/lisp-control-plane-linux_v3.1/opencp_xtr_nuovo.xml")

        mapservers = doc.getElementsByTagName("mapserver")
        for mapserver in mapservers:

                ms1 = mapserver.getElementsByTagName("ms")[0]
                ms2 = mapserver.getElementsByTagName("ms")[1]
                print("Map-server1: %s, Map-server2: %s\n" % (ms1.firstChild.data, ms2.firstChild.data))

        mapresolve = doc.getElementsByTagName("mr")[0]
        print("Map-resolve: %s\n" % mapresolve.firstChild.data)

        eids= doc.getElementsByTagName("eid")
        for eid in eids:

                prefix = eid.getAttribute("prefix")
                rloc = eid.getElementsByTagName("address")[0]
                dest = rloc.firstChild.data
                address.append(prefix)
                address.append(",")
                address.append(dest)
                address.append("-")

                print("eid:%s, rloc:%s\n" %(prefix, rloc.firstChild.data))
        address = ''.join(address)

        address1,address2,empty = address.split("-")


        try :

                #Set the whole string
                if (tmp_address1!=address1 or tmp_address2!=address2):
                        c.sendto(address, (host_address, port_host)) #msg
                        # receive data from client (data, addr)
                        d = c.recvfrom(1024)
                        reply = d[0]
                        addr = d[1]
                        print 'Server reply : ' +reply

                else:
                        print '\n NON INVIO NULLA \n'
                tmp_address1=address1
                tmp_address2=address2
                address = []

                # receive data from client (data, addr)
                #d = s.recvfrom(1024)
                #reply = d[0]
                #addr = d[1]

                #print 'Server reply : ' + reply

        except socket.error, msg:
                print 'Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
                sys.exit()


def timer():
  threading.Timer(10.0, timer).start()
  parse()

wait()






