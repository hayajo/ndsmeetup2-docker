#!/bin/sh

/usr/sbin/httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
  Hello. My hostname is `hostname`.
</body>
</html>
EOF

/usr/bin/serf agent -role app -join $LB_PORT_7946_TCP_ADDR -node $(hostname) &

exec /bin/bash
