#!/bin/bash
 
echo 'Hallo'
for ((i=1; i < 255; i++)) ; do
    ip=192.168.14.$i
        timeout 0.05 ping -c1 $ip > /dev/null 2>&1
 
    if [ $? -eq 0 ]; then
        echo "$ip ist erreichbar"
    fi
done

