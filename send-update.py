#!/usr/bin/python3

import socket
from os import listdir

animeID = listdir("current")[0].split("-")[-1].split(".")[0].strip()
UDP_IP = "172.22.37.103"
UDP_PORT = 4444
MESSAGE = "root/anime:"+animeID

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.sendto(bytes(MESSAGE,"utf-8"), (UDP_IP, UDP_PORT))

UDP_IP = "172.22.37.22"
sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.sendto(bytes(MESSAGE,"utf-8"), (UDP_IP, UDP_PORT))
