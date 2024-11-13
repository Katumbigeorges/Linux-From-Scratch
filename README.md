

# Building Your Own Linux Distribution

## Introduction
In the ever-evolving landscape of operating systems, understanding the fundamentals of Linux distribution creation is crucial for system engineers and developers. This project guides you through building a custom Linux distribution from scratch, providing hands-on experience with kernel configuration, system initialization, and userspace setup.

> Important Note: This project is school project in the course of Linux and serves educational purposes. The resulting distribution should be used in a controlled environment (virtual machine) for learning and testing.

## Project Overview
The linux from scratch project demonstrates the complete process of building a functional Linux distribution from source. It covers everything from kernel compilation to userspace configuration, showcasing the essential components needed for a working Linux system while allowing for personal customization and optimization.

## Features
1. Custom-built Linux distribution including:
   - Personalized kernel configuration
   - Bootloader setup (GRUB/LILO)
   - System initialization (SystemD/SysV)
   - Network connectivity
   - Package management system
   - User space utilities

2. Three-partition system structure:
   - Boot partition
   - Root partition
   - Swap partition

3. Customizable components:
   - Kernel modules selection
   - System services configuration
   - Network settings
   - Development environment

## Requirements
### Base System
- Kernel version >= 4.0
- 32 or 64-bit architecture support
- Kernel module loader (udev)
- Central management software (SystemD/SysV)
- Bootloader (GRUB/LILO)

### File Structure
- Kernel sources: /usr/src/kernel-$(version)
- Kernel binary: /boot/vmlinuz-<linux_version>-<student_login>
- System hostname: <student_log

## Installation Guide
1. Set up a virtual machine (VirtualBox/VMWare)
2. Create and configure partitions:
   	bash
   # Create partitions
   fdisk /dev/sda
   
   # Format partitions
   mkfs.ext4 /dev/sda1  # boot
   mkswap /dev/sda2     # swap
   mkfs.ext4 /dev/sda3  # root
   

3. Build and install the kernel:
   	bash
   # Configure kernel
   make menuconfig
   
   # Compile kernel
   make && make modules_install
   

4. Configure system components

## Required Packages
### Core System
- Acl (2.2.52)
- Attr (2.4.47)
- Autoconf (2.69)
- Automake (1.15)
- Bash (4.3.30)

### Development Tools
- Binutils (2.25.1)
- GCC (5.2.0)
- Make (4.1)
- Perl (5.22.0)

### System Utilities
- Coreutils (8.24)
- Util-linux (2.27)
- E2fsprogs (1.42.13)

[Complete package list available in the subject PDF]

## Bonus Features
Enhance your distribution with:
- X Server installation
- Window managers (GNOME/KDE/i3/dwm)
- Custom development environment
- Additional system utilities
- Security enhancements

## Contributing

This is an educational project for the class of linuxfoundation. 

## Additional Resources
- [Linux From Scratch Guide](https://www.linuxfromscratch.org/)
- [Kernel Documentation](https://www.kernel.org/doc/)
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)

⭐ If you find this project helpful, please consider giving it a star!