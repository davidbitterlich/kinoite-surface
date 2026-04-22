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

# Restore kernel-install
pushd /usr/lib/kernel/install.d

mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install

popd

### Install packages

dnf5 install -y tmux 

systemctl enable podman.socket
