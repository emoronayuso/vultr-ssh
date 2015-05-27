#!/bin/bash
# Require vultr-cli https://github.com/yikaus/vultrcli
# NOTE: Resolve IPs from Local DNS from /etc/hosts (comand host)
port_ssh="22" # Port ssh 
api_key="" # Api key vultr
clear
#/usr/local/bin/vucli.py serverlist -k $api_key|awk '{print $2}'|grep -v label|sort > /tmp/vpsvultr 
#/usr/local/bin/vucli serverlist -k $api_key | grep -oiE '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v 255 | awk '{system("host "$0)}' | grep "name pointer" | cut -d " " -f 5 > /tmp/vpsvultr

cat /etc/hosts |  grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}' | tr -s " " > /tmp/hosts

rm /tmp/vpsvultr

/usr/local/bin/vucli serverlist -k $api_key | grep -oiE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{system("grep " $0 " /tmp/hosts >> /tmp/vpsvultr")}'

cat /tmp/vpsvultr | cut -d ' ' -f 2 | cat -b
echo ""
printf '%s ' 'vps number?'
read -${BASH_VERSION+e}r vps
vps2=$(sed -n $vps"p" /tmp/vpsvultr|awk '{print $1}')
echo $vps2
printf '%s ' 'user?'
read -${BASH_VERSION+e}r user
ssh $user@$vps2 -p $port_ssh
exit 0
