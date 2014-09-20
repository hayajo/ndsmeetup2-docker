#!/bin/bash

/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -D -p "/var/run/haproxy.pid"
/usr/bin/serf agent -config-file=/etc/serf/lb.json &

exec /bin/bash
