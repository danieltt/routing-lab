Scripts for managing lxc for lab manager
==============================

Author
======
Copyright (C) Daniel Turull <danieltt@kth.se>

What is it?
===========
Set of scripts to create containers interconnected with bridges for networking labs.
Each link can be monitored.
Routers are based on Linux Bifrost

Usage
=====

This scripts rely on lxc containers.
Tested in Ubuntu 12.04 LTS

All the commands to be run as root.

NOTE: uncompress bifrost.tar first to create the file system
tar xvf bifrost.tgz

To create the envirorment use:
./manage-topology create

Then for starting use:
./manage-topoloy start

Once done, to stop use:
./manage-topolgy stop

and for the clean up
./manage-topology destroy

To see which containers are running use
lxc-ls

And to access the router with the console
lxc-console --name <name>
user: root
password: time2work


Type <Ctrl+a q> to exit the console

Configuration
============

Change router password
----------------------
Password can be changed using chroot envirorment on the bifrost file system
mount -t proc proc proc/
mount -t sysfs sys sys/
mount -o bind /dev dev/
mount -t devpts pts dev/pts/

chroot bifrost /bin/bash
passwd

Change topology
---------------
to change topology modify config file
addHost <name>
addLink <src> <dst>
