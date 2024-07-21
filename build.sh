#!/bin/bash

arches=(aarch64 armv7h x86_64)

# Ensure we have arch-install-scripts qemu-user-static and binfmt-qemu-static installed
sudo pacman -S --noconfirm --needed arch-install-scripts qemu-user-static qemu-user-static-binfmt
base="base sed gzip archlinux-keyring bredos-mirrorlist bredos-keyring bredos-logo bred-os-release sudo arch-install-scripts nano base-devel"
armv7h_packages="archlinuxarm-keyring $base"
aarch64_packages="archlinuxarm-keyring bredos-multilib $base"
x86_64_packages="$base"

script_dir=$(dirname "$(readlink -f "$0")")

# build for arch lulw
build_arch() {
    local arch=$1
    rm -rf "$script_dir/build/rootfs" || true
    sudo mkdir -pv "$script_dir/build/rootfs"
    sudo cp -rv "$script_dir/rootfs/$arch/"* "$script_dir/build/rootfs"
    sudo cp -rv "$script_dir/rootfs/common/"* "$script_dir/build/rootfs"
    local packages_var="${arch}_packages"
    sudo pacstrap -c -C "$script_dir/pacman.conf.$arch" -G -M "$script_dir/build/rootfs" ${!packages_var}
}

# Chek for arg
if [ $# -eq 1 ]; then
    # shellcheck disable=SC2199
    # shellcheck disable=SC2076
    if [[ " ${arches[@]} " =~ " $1 " ]]; then
        build_arch "$1"
    else
        echo "Invalid architecture: $1"
        echo "Valid architectures are: ${arches[*]}"
        exit 1
    fi
fi
