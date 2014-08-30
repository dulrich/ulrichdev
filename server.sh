#!/bin/bash

make all

set -m

node server.js &

trap "kill $!" SIGINT SIGTERM EXIT

fg %1