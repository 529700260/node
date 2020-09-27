#!/bin/bash
__run_node() {
  pm2 start index.js --no-daemon --node-args='--max-old-space-size=8192'
}

# Call all functions
__run_node