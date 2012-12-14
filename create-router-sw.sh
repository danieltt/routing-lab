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
lxc.network.type = veth
lxc.network.flags = up
lxc.network.link = $eth
EOF
fi
i=$[$i+1]
done

cat >> $LXC_CONF << EOF
lxc.devttydir = lxc
lxc.tty = 4
lxc.pts = 1024

lxc.cap.drop = sys_module mac_admin
lxc.pivotdir = lxc_putold

lxc.cgroup.devices.deny = a
# Allow any mknod (but not using the node)
lxc.cgroup.devices.allow = c *:* m
lxc.cgroup.devices.allow = b *:* m
# /dev/null and zero
lxc.cgroup.devices.allow = c 1:3 rwm
lxc.cgroup.devices.allow = c 1:5 rwm
# consoles
lxc.cgroup.devices.allow = c 5:1 rwm
lxc.cgroup.devices.allow = c 5:0 rwm
# /dev/{,u}random
lxc.cgroup.devices.allow = c 1:9 rwm
lxc.cgroup.devices.allow = c 1:8 rwm
lxc.cgroup.devices.allow = c 136:* rwm
lxc.cgroup.devices.allow = c 5:2 rwm
# rtc
lxc.cgroup.devices.allow = c 254:0 rwm
#fuse
lxc.cgroup.devices.allow = c 10:229 rwm
#tun
lxc.cgroup.devices.allow = c 10:200 rwm
#full
lxc.cgroup.devices.allow = c 1:7 rwm

lxc.rootfs = $PWD/$name
lxc.mount = $PWD/$fstab
EOF
