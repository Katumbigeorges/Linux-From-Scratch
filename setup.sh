#!/bin/bash
# LFS Project Setup Script
# This script prepares the environment for building Linux From Scratch

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root"
    exit 1
fi

log_info "Setting up LFS build environment..."

# Make scripts executable
log_info "Making scripts executable..."
chmod +x ft_linux*.sh
chmod +x config.sh
chmod +x setup.sh

# Create necessary directories
log_info "Creating directories..."
mkdir -p /var/log
mkdir -p /mnt/lfs

# Install required packages
log_info "Installing required packages..."
apt update
apt install -y \
    build-essential \
    bison \
    gawk \
    texinfo \
    wget \
    curl \
    git \
    openssl \
    fdisk \
    e2fsprogs \
    dosfstools

# Check for Vagrant (optional)
if command -v vagrant &> /dev/null; then
    log_success "Vagrant is installed"
else
    log_warning "Vagrant not found. Install it for automated builds:"
    log_warning "  https://www.vagrantup.com/downloads"
fi

# Check for VirtualBox (optional)
if command -v VBoxManage &> /dev/null; then
    log_success "VirtualBox is installed"
else
    log_warning "VirtualBox not found. Install it for VM builds:"
    log_warning "  https://www.virtualbox.org/wiki/Downloads"
fi

# Check disk space
available_space=$(df / | awk 'NR==2 {print $4}')
if [[ $available_space -lt 10485760 ]]; then
    log_error "Insufficient disk space. Need at least 10GB free"
    exit 1
else
    log_success "Disk space check passed ($(($available_space / 1024 / 1024))GB available)"
fi

# Check for second disk
if [[ -b /dev/sdb ]]; then
    log_success "Second disk (/dev/sdb) found"
else
    log_warning "Second disk (/dev/sdb) not found"
    log_warning "You'll need to attach a second disk for the LFS build"
fi

# Create log files
touch /var/log/lfs-build.log
touch /var/log/lfs-errors.log

log_success "Setup completed successfully!"
log_info "You can now run:"
log_info "  sudo ./ft_linux.sh    # For manual build"
log_info "  vagrant up            # For automated VM build"
log_info ""
log_info "For troubleshooting, see TROUBLESHOOTING.md"
