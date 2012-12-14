==============================
Scripts for managing lxc for lab manager
==============================

Author
======
Copyright (C) Daniel Turull <danieltt@kth.se>

What is it?
===========
Set of scripts to create containers interconnected with bridges for networking labs. It uses lxc based virtualization.

Each link between routers can be monitored with wireshark or similar.

Routers are based on Linux Bifrost.

Usage
=====

This scripts rely on lxc containers. Tested in Ubuntu 12.04 LTS

All the commands to be run as root.

NOTE: uncompress bifrost.tar first to create the file system
::
   sudo tar xvf bifrost.tgz

To create the envirorment use:
::
   sudo ./manage-topology create

Then for starting use:
::
   sudo ./manage-topoloy start

Once done, to stop use:
::
   sudo ./manage-topolgy stop

and for the clean up
::
   ./manage-topology destroy

To see which containers are running use
::
    lxc-ls

And to access the router with the console. **user:** root **password:** time2work
::
  lxc-console --name <name>

Type <Ctrl+a q> to exit the console

Configuration
============

Change router password
----------------------
Password can be changed using chroot envirorment on the bifrost file system
::
   mount -t proc proc bifrost/proc/
   mount -t sysfs sys bifrost/sys/
   mount -o bind /dev bifrost/dev/
   mount -t devpts pts bifrost/dev/pts/
   chroot bifrost /bin/bash
   passwd
   <write password>
   exit

Change topology
---------------
to change topology modify config file

addHost <name>

addLink <src> <dst>
