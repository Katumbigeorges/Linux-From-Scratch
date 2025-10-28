#!/bin/bash
# LFS Build Configuration File
# Modify these settings to customize your build

# Build Configuration
export LFS_VERSION="11.0"
export LFS_HOSTNAME="lfs-system"
export LFS_TGT="x86_64-lfs-linux-gnu"

# Disk Configuration
export LFS_DISK="/dev/sdb"
export LFS_BOOT_SIZE="200M"
export LFS_SWAP_SIZE="2G"

# Build Optimization
export LFS_CORES=$(nproc)
export LFS_MAKEFLAGS="-j$LFS_CORES"

# Network Configuration
export LFS_IP="192.168.42.110"
export LFS_NETMASK="255.255.255.0"
export LFS_GATEWAY="192.168.42.1"

# Package Versions (for reference)
export KERNEL_VERSION="5.13.12"
export GCC_VERSION="11.2.0"
export GLIBC_VERSION="2.34"
export BINUTILS_VERSION="2.37"

# Build Directories
export LFS="/mnt/lfs"
export LFS_SOURCES="$LFS/sources"
export LFS_TOOLS="$LFS/tools"

# Logging
export LFS_LOG="/var/log/lfs-build.log"
export LFS_ERROR_LOG="/var/log/lfs-errors.log"

# Security
export LFS_ROOT_PASSWORD_LENGTH="32"

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LFS_LOG"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LFS_LOG"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LFS_LOG"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LFS_LOG" >&2
}

# Validation functions
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

check_disk_space() {
    local required_space=10485760  # 10GB in KB
    local available_space=$(df / | awk 'NR==2 {print $4}')
    
    if [[ $available_space -lt $required_space ]]; then
        log_error "Insufficient disk space. Need at least 10GB free"
        exit 1
    fi
}

check_disk_device() {
    if [[ ! -b "$LFS_DISK" ]]; then
        log_error "Disk device $LFS_DISK not found"
        exit 1
    fi
}

# Initialize logging
init_logging() {
    mkdir -p "$(dirname "$LFS_LOG")"
    touch "$LFS_LOG" "$LFS_ERROR_LOG"
    log_info "Starting LFS build process at $(date)"
}

# Source this file in other scripts
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is a configuration file. Source it in your scripts:"
    echo "source ./config.sh"
fi
