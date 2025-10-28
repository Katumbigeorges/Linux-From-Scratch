# Linux From Scratch (LFS) Build Project

## 🐧 Project Overview

This project demonstrates how to build a complete Linux distribution from source code, following the official [Linux From Scratch (LFS) 11.0](https://www.linuxfromscratch.org/lfs/view/11.0/) guidelines. It's designed as an educational project for understanding the fundamentals of Linux system architecture, kernel compilation, and distribution creation.

> **⚠️ Educational Purpose Only**: This project is intended for learning and should only be used in controlled virtual environments.

## 🎯 What This Project Does

### Core Features
- **Custom Linux Kernel**: Compiles and configures a personalized Linux kernel
- **Complete Toolchain**: Builds GCC, binutils, and other essential development tools
- **System Libraries**: Installs glibc, libffi, and other core system libraries
- **Essential Utilities**: Provides bash, coreutils, vim, and other basic tools
- **Bootable System**: Creates a fully functional, bootable Linux system

### System Architecture
- **Three-Partition Layout**:
  - `/dev/sdb1`: Boot partition (200MB, ext2)
  - `/dev/sdb2`: Swap partition (2GB)
  - `/dev/sdb3`: Root partition (remaining space, ext4)
- **Custom Hostname**: Configurable system hostname
- **Secure Authentication**: Random password generation for root account

## 🚀 Quick Start

### Prerequisites
- **Host System**: Ubuntu 20.04+ (tested on Ubuntu Server 20.04.3 LTS)
- **Hardware**: Minimum 4GB RAM, 30GB free disk space
- **Software**: VirtualBox, Vagrant, Git
- **Network**: Internet connection for downloading sources

### Automated Build (Recommended)
```bash
# Clone the repository
git clone <repository-url>
cd Linux-From-Scratch

# Run setup script
sudo ./setup.sh

# Start the automated build
vagrant up
```

The build process will:
1. **Phase 1**: Set up partitions, install dependencies, prepare environment
2. **Phase 2**: Build cross-toolchain and temporary tools
3. **Phase 3**: Compile final system and create bootable image

### Manual Build
```bash
# Run setup first
sudo ./setup.sh

# Run as root
sudo ./ft_linux.sh    # Initial setup and partitioning
sudo ./ft_linux2.sh   # Cross-toolchain build
sudo ./ft_linux3.sh   # Final system build
```

## 📁 Project Structure

```
Linux-From-Scratch/
├── ft_linux.sh          # Phase 1: Initial setup script
├── ft_linux2.sh         # Phase 2: Cross-toolchain script  
├── ft_linux3.sh         # Phase 3: Final system script
├── config.sh            # Build configuration and utilities
├── setup.sh             # Environment setup script
├── Vagrantfile          # Virtual machine configuration
├── wget-list            # Source package URLs
├── sources/             # Downloaded source packages
│   ├── linux-5.13.12.tar.xz
│   ├── gcc-11.2.0.tar.xz
│   ├── glibc-2.34.tar.xz
│   └── ... (90+ packages)
├── map.pdf              # Detailed package information
├── TROUBLESHOOTING.md   # Comprehensive troubleshooting guide
└── README.md            # This file
```

## 🔧 Build Process Details

### Phase 1: Initial Setup (`ft_linux.sh`)
- **Prerequisites Check**: Validates system requirements
- **Dependency Installation**: Installs build tools (GCC, make, etc.)
- **Disk Partitioning**: Creates boot, swap, and root partitions
- **Environment Setup**: Configures LFS environment variables
- **Source Download**: Downloads all required source packages

### Phase 2: Cross-Toolchain (`ft_linux2.sh`)
- **Binutils**: First pass compilation
- **GCC**: Cross-compiler toolchain
- **Linux Headers**: Kernel headers installation
- **Glibc**: C library compilation
- **Toolchain Verification**: Tests the cross-compilation environment

### Phase 3: Final System (`ft_linux3.sh`)
- **Chroot Environment**: Enters the LFS filesystem
- **Core Utilities**: Installs essential system tools
- **System Configuration**: Sets up users, services, and networking
- **Bootloader**: Installs GRUB for system booting
- **Final Cleanup**: Removes temporary files and optimizes system

## 📦 Included Packages

### Core System (90+ packages)
- **Kernel**: Linux 5.13.12
- **Toolchain**: GCC 11.2.0, Binutils 2.37, Make 4.3
- **Libraries**: Glibc 2.34, Libffi 3.4.2, Zlib 1.2.11
- **Utilities**: Bash 5.1.8, Coreutils 8.32, Vim 8.2.3337
- **Development**: Python 3.9.6, Perl 5.34.0, Git 2.33.0
- **System**: Systemd 249, OpenSSH 8.7p1, NetworkManager

### Complete Package List
See `map.pdf` for detailed package information and dependencies.

## 🛠️ Configuration Options

### Vagrant Configuration
```ruby
MEM = 4096          # RAM allocation (MB)
CPU = 3             # CPU cores
DISK_SIZE = 30 * 1024  # Disk size (MB)
BUILD_TIMEOUT = 7200    # Build timeout (seconds)
```

### Build Parameters
- **Parallel Jobs**: Automatically detects CPU cores for optimal compilation
- **Logging**: All build output is logged to `/var/log/lfs-build.log`
- **Error Handling**: Scripts fail fast on errors with detailed messages

## 🔍 Troubleshooting

### Common Issues

**Build Fails with "No space left on device"**
```bash
# Check available space
df -h
# Clean up if needed
sudo apt autoremove
```

**Permission Denied Errors**
```bash
# Ensure running as root
sudo su -
```

**Network Timeout During Download**
```bash
# Check internet connection
ping -c 3 google.com
# Retry download
wget -c <package-url>
```

**Vagrant VM Won't Start**
```bash
# Check VirtualBox installation
VBoxManage --version
# Restart VirtualBox services
sudo systemctl restart vboxdrv
```

### Debug Mode
Enable verbose logging:
```bash
# Add to script beginning
set -x  # Enable debug mode
```

### Recovery
If build fails, you can resume from any phase:
```bash
# Resume from Phase 2
vagrant ssh
sudo -u lfs ./ft_linux2.sh

# Resume from Phase 3  
vagrant ssh
sudo ./ft_linux3.sh
```

## 📚 Educational Value

This project teaches:
- **Linux Kernel Architecture**: Understanding kernel compilation and configuration
- **System Boot Process**: GRUB, init systems, and system initialization
- **Package Management**: Dependency resolution and build systems
- **System Administration**: User management, service configuration, networking
- **Development Tools**: Cross-compilation, debugging, and optimization

## 🔒 Security Features

- **Random Password Generation**: Secure root password creation
- **Error Handling**: Prevents partial builds and security issues
- **Input Validation**: Checks system requirements before starting
- **Logging**: Comprehensive audit trail of all operations

## 📖 Additional Resources

- [Official LFS Guide](https://www.linuxfromscratch.org/lfs/view/11.0/)
- [Kernel Documentation](https://www.kernel.org/doc/)
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [GNU Coding Standards](https://www.gnu.org/prep/standards/)

## 🤝 Contributing

This is an educational project. Contributions that improve:
- Documentation clarity
- Error handling robustness  
- Build process efficiency
- Educational value

Are welcome and appreciated!

## 📄 License

This project is for educational purposes. Please refer to individual package licenses for source code usage.

---

**⭐ If you find this project helpful for learning Linux internals, please consider giving it a star!**

*Built with ❤️ for the Linux community*