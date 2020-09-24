#!/bin/bash
__run_node() {
  echo $1
  if [ -n "$1" ];then
  echo -e "$1\n$1" | (passwd)
  /usr/sbin/sshd
  fi
  pm2 start index.js --no-daemon --node-args='--max-old-space-size=8192'
}

# Call all functions
__run_node $1