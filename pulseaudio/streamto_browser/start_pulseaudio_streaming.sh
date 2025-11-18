#!/bin/sh

sd=$(dirname $(realpath "$0"))

node "$sd/server.js" &

python3 -m http.server 8000
