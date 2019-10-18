#!/bin/bash --login

# mount -o remount,size=64M /dev/shm

su - oracle <<!
lsnrctl stop

sqlplus / as sysdba <<EOF
shutdown immediate
exit
EOF

!

