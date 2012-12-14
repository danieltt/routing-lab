#!/bin/bash
set -e
#    Copyright (C) 2011  Daniel Turull <danieltt@kth.se>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.)

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
