#!/bin/bash

# Shell script to create a partition in Linux

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

echo "Available disks:"
lsblk -d -e 7 -o NAME,SIZE

# Ask for the disk name (e.g., /dev/sda)
read -p "Enter the disk name (e.g., /dev/sda): " disk

# Validate the disk
if [[ ! -b $disk ]]; then
    echo "Invalid disk name: $disk"
    exit 1
fi

# Show the current partition table
echo "Current partition table for $disk:"
fdisk -l "$disk"

# Confirm the user wants to proceed
read -p "Do you want to create a new partition on $disk? (yes/no): " confirm
if [[ $confirm != "yes" ]]; then
    echo "Operation canceled."
    exit 0
fi

# Use fdisk to create a new partition
(
echo n    # Add a new partition
echo p    # Select primary partition
echo      # Default partition number
echo      # Default first sector
echo      # Default last sector (use entire free space)
echo w    # Write changes
) | fdisk "$disk"

# Inform the user about changes
echo "Partition creation complete. Updated partition table:"
fdisk -l "$disk"

# Notify the user about formatting the partition
read -p "Do you want to format the new partition? (yes/no): " format
if [[ $format == "yes" ]]; then
    # Get the name of the new partition
    new_partition=$(lsblk -no NAME "$disk" | tail -1)
    read -p "Enter the filesystem type (e.g., ext4, xfs): " fs_type
    mkfs -t "$fs_type" "/dev/$new_partition"
    echo "Partition /dev/$new_partition formatted as $fs_type."
fi

echo "Script completed."

