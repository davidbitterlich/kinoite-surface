#!/bin/bash

set -ouex pipefail

### Remove Ublue-Kernel
rpm --erase kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra virtualbox-guest-additions

### Add the surface kernel repository
dnf5 config-manager addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo

### Install surface packages
dnf5 install --allowerasing -y kernel-surface iptsd libwacom-surface surface-secureboot

### Install packages

dnf5 install -y tmux 

systemctl enable podman.socket
