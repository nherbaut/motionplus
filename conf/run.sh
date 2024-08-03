mkdir -p /var/log
motionplus -b -c /etc/motionplus/motionplus.conf -p /dev/motionplus.pid -m
tail -f /var/log/motionplus.log