#!/bin/bash

set -ouex pipefail

### disable kernel-install hooks
pushd /usr/lib/kernel/install.d

mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak

printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install

chmod +x 05-rpmostree.install 50-dracut.install

popd

### Install surface packages
dnf5 install -y --allowerasing /tmp/packages/*.rpm
rpm -qa 'kernel*' | grep -v surface | xargs -r dnf5 remove -y

# Restore kernel-install
pushd /usr/lib/kernel/install.d

mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install

popd
