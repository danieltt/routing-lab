#!/bin/bash
#Example of topology
#AUTHOR: Daniel Turull (danieltt@kth.se)

source "functions.sh"
source "config"
topoName=ripBasic
#ROUTER CONNECTIONS

if [ "$(id -u)" != "0" ]; then
  echo "You need to be root"
  exit
fi

case "$1" in
  create)
	createRouters
	;;
  start)
	createLinks
	for name in ${names[@]}
	do
	  lxc-start -n $name -d
	done
	;;
  stop)
	for name in ${names[@]}
	do
	  lxc-stop -n $name 
	done
	;;
  destroy)
	for name in ${names[@]}
	do
	  lxc-stop -n $name 
	  lxc-destroy -n $name 
  	  rm -rf $name conf/lxc-$name.conf conf/fstab.$name
	done
	deleteSW
	;;
  *)
	echo "Usage $0 {create|start|stop|destroy}"
esac
exit

#!/bin/bash
