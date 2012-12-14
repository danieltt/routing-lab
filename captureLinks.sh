#!/bin/bash
source functions.sh
source config
if [ "$(id -u)" != "0" ]; then
  echo "You need to be root"
  exit
fi

createLinksName
for link in ${sw[@]}; do
  echo "Lauching wireshark for $link"
  wireshark -i $link -k &
done
