#!/bin/bash --login

# mount -o remount,size=4G /dev/shm

su - oracle <<!
lsnrctl start

sqlplus / as sysdba <<EOF
startup
exit
EOF

!
