#!/bin/bash
if [ $# -lt 2 ]
then
    echo "At least two argument are required in $0"
    echo "Syntax: $0 name veth0 [veth1] ... "
    exit
fi
name=$1
PWD=`pwd`
rm -rf $name
cp -rf bifrost $name
#set HOSTNAME
echo $1 > $name/etc/HOSTNAME

#FSTAB FILE
fstab=conf/fstab.$name
cat > $fstab << EOF
none $PWD/$name/dev/pts devpts defaults 0 0
none $PWD/$name/proc proc defaults 0 0
none $PWD/$name/sys sysfs defaults 0 0
$PWD/shared $PWD/$name/shared none bind 0 0
EOF
LXC_CONF=conf/lxc-$name.conf
cat > $LXC_CONF << EOF
lxc.utsname = $name
EOF
i=0
for eth in $*
do
if [ $i -gt 0 ]
then
cat >> $LXC_CONF << EOF
lxc.network.type = phys
lxc.network.flags = down
lxc.network.link = $eth
EOF
fi
i=$[$i+1]
done

cat >> $LXC_CONF << EOF
# max number of pts
lxc.pts = 256
# nr of ttys
lxc.tty = 6
lxc.cgroup.devices.deny = a
# allow pts devices (should be limited to the tty ones)
lxc.cgroup.devices.allow = c 136:* rw
# /dev/pts/ptmx
lxc.cgroup.devices.allow = c 5:2 rw
# /dev/null, zero, random, urandom
lxc.cgroup.devices.allow = c 1:3 rw
lxc.cgroup.devices.allow = c 1:5 rw
lxc.cgroup.devices.allow = c 1:8 rw
lxc.cgroup.devices.allow = c 1:9 rw
lxc.rootfs = $PWD/$name
lxc.mount = $PWD/$fstab
EOF
