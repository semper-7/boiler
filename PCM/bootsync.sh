#!/bin/sh
# put other system startup commands here, the boot process will wait until they complete.
# Use bootlocal.sh for system startup commands that can run in the background 
# and therefore not slow down the boot process.
/usr/bin/sethostname box
echo "Setting IP"
ifconfig eth0 192.168.1.111 netmask 255.255.255.0
route add default gw 192.168.1.1 eth0
echo "nameserver 212.94.96.123" >> /etc/resolv.conf
echo "Start telnet server"
/usr/sbin/telnetd
echo "Start tftp server"
/sbin/udpsvd -E 0 69 /usr/sbin/tftpd -c /home/tc &
echo "start http web server"
/usr/local/httpd/sbin/httpd -p 80 -h /home/tc -u tc:staff
/opt/bootlocal.sh &
