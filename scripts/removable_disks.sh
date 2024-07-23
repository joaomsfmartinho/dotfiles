#!/bin/bash

## This script will list all removable disks attached to the system.
## For this, it uses udisksctl command output.
## The script starts by running udisksctl status command to get the list of all disks attached to the system.
## Then, it filters the output to get only the removable disks.
## Finally, it prints the list of removable disks.

## Get the list of all disks attached to the system
disks=$(udisksctl status | grep -o 'sd[a-z]*')

removable_disks=()

## TODO: Filter the removable disks from the list of all disks

## Print the list of removable disks
echo "Removable disks: ${removable_disks[@]}"

