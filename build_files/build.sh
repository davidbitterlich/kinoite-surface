#!/bin/bash

set -ouex pipefail

### Add the surface kernel repository
dnf5 config-manager addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo

### disable kernel-install hooks
pushd /usr/lib/kernel/install.d

mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak

printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install

chmod +x 05-rpmostree.install 50-dracut.install

popd

### Install surface packages
dnf5 install --allowerasing -y kernel-surface iptsd libwacom-surface surface-secureboot
rpm -qa 'kernel*' | grep -v surface | xargs -r dnf5 remove -y

# Restore kernel-install
pushd /usr/lib/kernel/install.d

mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install

popd

### Install packages
PACKAGES=(
    tmux
    screen
    distrobox
    gvfs
    gvfs-fuse
    zsh
    autofs
    evtest
    fastfetch
    git-credential-libsecret
    gvfs
    gvfs-fuse
    igt-gpu-tools
    input-remapper
    iwd
    krb5-workstation
    ksystemlog
    libxcrypt-compat
    lm_sensors
    oddjob-mkhomedir
    plasma-wallpapers-dynamic
    rclone
    samba-winbind
    samba-winbind-clients
    samba-winbind-modules
    setools-console
    tesseract-devel
    tesseract-langpack-{eng,deu,fra,spa,por,ita,pol,fin,nld,jpn,jpn_vert,hin,chi_sim,chi_sim_vert,chi_tra,chi_tra_vert}
    vim
    uld
    btop
    qemu
    qemu-kvm
    qemu-img
    qemu-char-spice
    qemu-device-display-virtio-gpu
    qemu-device-display-virtio-vga
    qemu-device-usb-redirect
    qemu-system-x86-core
    qemu-user-binfmt
    qemu-user-static
    p7zip
    p7zip-plugins
    virt-viewer
    podman-compose
    podman-machine
    podman-tui
    libvirt
    libvirt-nss
    edk2-ovmf
)
dnf5 -y install "${PACKAGES[@]}"

### Remove packages
EXCLUDED_PACKAGES=(
    akonadi-server
    akonadi-server-mysql
    default-fonts-cjk-sans
    fedora-bookmarks
    fedora-chromium-config
    fedora-chromium-config-kde
    fedora-third-party
    ffmpegthumbnailer
    firefox
    firefox-langpacks
    google-noto-sans-cjk-vf-fonts
    kcharselect
    khelpcenter
    krfb
    krfb-libs
    plasma-discover-kns
    plasma-discover-rpm-ostree
    plasma-welcome-fedora
    podman-docker
)
dnf5 -y remove "${EXCLUDED_PACKAGES[@]}"

systemctl enable podman.socket
