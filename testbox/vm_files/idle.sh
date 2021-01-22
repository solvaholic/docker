#!/bin/sh
cd || exit
touch ./keeprunning
while [ -f ./keeprunning ]; do
  sleep 5
done
