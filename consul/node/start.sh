#!/bin/bash

consul agent -data-dir=/tmp/consul -pid-file=/var/run/consul.pid $@ &

cat <<EOF >~/.bashrc
trap '/usr/local/bin/stop; exit 0' TERM
EOF

exec /bin/bash


