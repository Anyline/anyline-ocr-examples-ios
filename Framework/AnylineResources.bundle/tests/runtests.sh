#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage: runtests.sh /path/to/cli"
  	exit 1
fi

pip3 install -r tests/scripts/requirements.txt

sh tests/scripts/enable_testing.sh

python3 tests/scripts/testall.py "$1" 
