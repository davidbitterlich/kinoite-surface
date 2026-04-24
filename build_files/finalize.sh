#!/bin/bash

set -euxo pipefail

KVER=$(rpm -q --queryformat="%{VERSION}-%{RELEASE}.%{ARCH}" kernel-surface-core)

export DRACUT_NO_XATTR=1

mkdir -p /var/tmp
chmod 1777 /var/tmp

sed -i '/\/root/d' /etc/dracut.conf.d/*.conf || true
dracut \
  --no-hostonly \
  --kver "${KVER}" \
  --reproducible \
  -v \
  --add ostree \
  -f "/lib/modules/${KVER}/initramfs.img"

chmod 0600 "/lib/modules/${KVER}/initramfs.img"