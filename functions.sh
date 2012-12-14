#!/bin/bash
#Example of topology
#AUTHOR: Daniel Turull (danieltt@kth.se)

function addLink {
  last=${#link[@]}
  next=$[$last+1]  
  link[$last]=$1
  link[$next]=$2
}

function addHost {
  last=${#names[@]}
  next=$[$last+1]  
  names[$last]=$1
  names[$next]=$2
}

function createLinksName {
  #create virtual links
  for (( i=0; i<${#link[@]}; i=$i+2 ));
  do
    last=${#sw[@]}
    next=$[$i+1]
    sw_name=link-${link[$i]}-${link[$next]}
    sw[$last]=$sw_name
    #echo "sw[$last]=$sw_name"
  done
}

function createLinks {
  createLinksName
  for link in ${sw[@]}; do
    brctl addbr $link
    ifconfig $link up
  done
}
function createRouters {
  createLinksName

  #echo "Create new router SW"
  #choose interface to insert to the containers
  for name in ${names[@]}
  do
    declare -a arg=()
    for vswitch in ${sw[@]}
    do
      #echo $vswitch
      SRC=`echo $vswitch | cut -d'-' -f 2`
      DST=`echo $vswitch | cut -d'-' -f 3`
      if [ $SRC = $name ] ; then
        last=${#arg[@]}
        arg[$last]=$vswitch
      fi
      if [ $DST = $name ] ; then
        last=${#arg[@]}
        arg[$last]=$vswitch
      fi
    done
    # echo LINKS FOR $name ${arg[@]}
    ./create-router-sw.sh $name ${arg[@]}
    #echo "./create-router-sw.sh $name ${arg[@]}"
    lxc-create -n $name -f conf/lxc-$name.conf
  done

  echo ${names[@]} > $topoName.run
  echo Topology created: $topoName
}

function deleteSW {
  createLinksName
  for vswitch in ${sw[@]}
  do
    echo "Deleting $vswitch"
    ifconfig $vswitch down
    brctl delbr $vswitch
  done 
}

#ROUTER CONNECTIONS
declare -a names
declare -a sw
declare -a link

