#!/bin/bash

# start sshd
__run_() {
  echo -e "123456\n123456" | (passwd)
  /usr/sbin/sshd -D
}

# start node
__start_pm2() {
  cd /var/www/Moniti
  npm i
  pm2 start index.js --name moniti --node-args='--max-old-space-size=2048'
  cd /var/www/MoniDev
  npm i
  pm2 start index.js --name monidev --node-args='--max-old-space-size=2048'
}

__start_cpp() {
  cd /var/www/Forever/bin
  ./forever >/dev/null 2>&1 &
}

# run
__start_pm2
__start_cpp
__run_ $1
