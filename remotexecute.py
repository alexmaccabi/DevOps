__author__ = 'alexm'
#!/usr/bin/python
#import sys, os, base64, getpass, socket, traceback, termios, tty, select
import paramiko, getpass

serverList = ["127.0.0.1"] # Enter the server list ["serverip1","serverip2"]

command= raw_input("Command: ") # Enter command ps, df
userName= raw_input("User: ")
userPass=getpass.getpass("Password: ")

# loops trough the server list and executes the command

for server in serverList:
        t = paramiko.Transport((server,22))
        try:
                t.connect(username=userName,password=userPass,hostkey=None)
        except:
                print (server + ": Bad password or login!")
                t.close()
                break
        else:
                ch = t.open_channel(kind = "session")
                ch.exec_command(command)
                if (ch.recv_ready):
                        print (server + ": " + ch.recv(1000))