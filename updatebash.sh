#!/bin/bash
# this script update the bash shell it was made for Ubuntu 12.04.*

servers=(
serverip

)
# loops trought the server list.
for server in ${servers[@]}
do
# connect to every server and executes the command.
ssh $server 'wget http://security.ubuntu.com/ubuntu/pool/main/b/bash/bash_4.3-10ubuntu1_amd64.deb && dpkg -i bash_4.3-10ubuntu1_amd64.deb'

done