# LFS Build Troubleshooting Guide

## 🚨 Common Issues and Solutions

### Build Environment Issues

#### "Permission Denied" Errors
**Problem**: Scripts fail with permission errors
```bash
./ft_linux.sh: Permission denied
```

**Solution**:
```bash
# Make scripts executable
chmod +x ft_linux*.sh

# Run as root
sudo ./ft_linux.sh
```

#### "No space left on device"
**Problem**: Build fails due to insufficient disk space
```bash
No space left on device
```

**Solutions**:
```bash
# Check available space
df -h

# Clean up package cache
sudo apt clean
sudo apt autoremove

# Check LFS partition space
df -h /mnt/lfs

# Clean up build sources if needed
sudo rm -rf /mnt/lfs/sources/*
```

#### "Disk device not found"
**Problem**: Script can't find /dev/sdb
```bash
Error: /dev/sdb not found
```

**Solutions**:
```bash
# List available disks
lsblk

# Check if disk is attached
sudo fdisk -l

# For Vagrant, ensure second disk is attached
# Check Vagrantfile configuration
```

### Network Issues

#### Download Timeouts
**Problem**: Source packages fail to download
```bash
wget: unable to resolve host address
```

**Solutions**:
```bash
# Test internet connectivity
ping -c 3 google.com

# Check DNS resolution
nslookup github.com

# Use different mirror
# Edit wget-list with alternative URLs
```

#### SSH Connection Issues
**Problem**: Vagrant can't connect to VM
```bash
ssh: connect to host 192.168.42.110 port 22: Connection refused
```

**Solutions**:
```bash
# Check VM status
vagrant status

# Restart VM
vagrant reload

# Check SSH service
vagrant ssh
sudo systemctl status ssh

# Verify network configuration
ip addr show
```

### Compilation Issues

#### GCC Compilation Fails
**Problem**: GCC build fails with errors
```bash
make[1]: *** [Makefile:1234: target] Error 1
```

**Solutions**:
```bash
# Check available memory
free -h

# Reduce parallel jobs
export MAKEFLAGS="-j1"

# Check for missing dependencies
sudo apt install build-essential

# Clean and retry
make clean
make
```

#### "Missing header files"
**Problem**: Compilation fails due to missing headers
```bash
fatal error: linux/version.h: No such file or directory
```

**Solutions**:
```bash
# Install kernel headers
sudo apt install linux-headers-$(uname -r)

# Check LFS environment
echo $LFS
ls -la /mnt/lfs/usr/include/linux/
```

#### Glibc Compilation Issues
**Problem**: Glibc build fails
```bash
configure: error: Link tests are not allowed after GCC_NO_EXECUTABLES
```

**Solutions**:
```bash
# Ensure proper toolchain
export CC=$LFS_TGT-gcc
export CXX=$LFS_TGT-g++

# Check cross-compiler
$LFS_TGT-gcc --version

# Clean and reconfigure
make distclean
./configure --prefix=/usr --host=$LFS_TGT
```

### Chroot Environment Issues

#### "chroot: failed to run command"
**Problem**: Can't enter chroot environment
```bash
chroot: failed to run command '/bin/bash': No such file or directory
```

**Solutions**:
```bash
# Check if chroot environment is properly set up
ls -la /mnt/lfs/bin/bash

# Verify file permissions
chmod +x /mnt/lfs/bin/bash

# Check mount points
mount | grep lfs

# Remount if necessary
mount --bind /dev /mnt/lfs/dev
mount -t proc proc /mnt/lfs/proc
mount -t sysfs sysfs /mnt/lfs/sys
```

#### "Command not found" in chroot
**Problem**: Commands not available in chroot
```bash
bash: make: command not found
```

**Solutions**:
```bash
# Check PATH in chroot
echo $PATH

# Verify tool installation
ls -la /mnt/lfs/usr/bin/make

# Reinstall missing tools
# Exit chroot and run appropriate build phase
```

### Boot Issues

#### "No bootable device found"
**Problem**: System won't boot from LFS disk
```bash
No bootable device found
```

**Solutions**:
```bash
# Check GRUB installation
ls -la /mnt/lfs/boot/grub/

# Verify kernel installation
ls -la /mnt/lfs/boot/vmlinuz-*

# Reinstall GRUB
grub-install /dev/sdb
grub-mkconfig -o /mnt/lfs/boot/grub/grub.cfg
```

#### "Kernel panic" on boot
**Problem**: System boots but crashes with kernel panic
```bash
Kernel panic - not syncing: VFS: Unable to mount root fs
```

**Solutions**:
```bash
# Check root filesystem
fsck /dev/sdb3

# Verify kernel configuration
# Check if required filesystem support is enabled

# Check init system
ls -la /mnt/lfs/sbin/init
```

## 🔧 Debug Mode

### Enable Verbose Logging
```bash
# Add to script beginning
set -x  # Enable debug mode
set -e  # Exit on error
set -u  # Exit on undefined variable
```

### Check Build Logs
```bash
# View build log
tail -f /var/log/lfs-build.log

# Check for errors
grep -i error /var/log/lfs-build.log

# Check specific phase
grep "Phase 1" /var/log/lfs-build.log
```

### Manual Verification
```bash
# Check LFS environment
echo $LFS
ls -la $LFS

# Verify toolchain
$LFS_TGT-gcc --version
$LFS_TGT-ld --version

# Check installed packages
ls -la $LFS/usr/bin/
```

## 🆘 Recovery Procedures

### Resume Failed Build
```bash
# If Phase 1 failed
sudo ./ft_linux.sh

# If Phase 2 failed
sudo -u lfs ./ft_linux2.sh

# If Phase 3 failed
sudo ./ft_linux3.sh
```

### Clean Restart
```bash
# WARNING: This will delete all LFS data
sudo umount /mnt/lfs
sudo mkfs.ext4 /dev/sdb3
sudo mount /dev/sdb3 /mnt/lfs
sudo ./ft_linux.sh
```

### Partial Recovery
```bash
# Check what was completed
ls -la /mnt/lfs/usr/bin/

# Resume from specific package
cd /mnt/lfs/sources
tar -xf package-name.tar.xz
cd package-name
# Continue with package build
```

## 📞 Getting Help

### Log Collection
Before asking for help, collect these logs:
```bash
# System information
uname -a > debug-info.txt
df -h >> debug-info.txt
free -h >> debug-info.txt

# Build logs
cp /var/log/lfs-build.log debug-info.txt
cp /var/log/lfs-errors.log debug-info.txt

# LFS environment
env | grep LFS >> debug-info.txt
```

### Common Debug Commands
```bash
# Check system resources
htop
iostat -x 1

# Monitor build process
watch -n 1 'ps aux | grep make'

# Check disk usage
du -sh /mnt/lfs/*

# Verify network
curl -I https://github.com
```

## ⚠️ Important Notes

- **Always backup** your work before making changes
- **Test in VM** before running on physical hardware
- **Read error messages** carefully - they often contain the solution
- **Check logs** regularly during long builds
- **Be patient** - LFS builds can take several hours

---

*For additional help, refer to the [Official LFS Book](https://www.linuxfromscratch.org/lfs/view/11.0/) or the project's main README.md*
