#!/bin/bash

set -euxo pipefail

KVER=$(rpm -q --queryformat="%{VERSION}-%{RELEASE}.%{ARCH}" kernel-surface-core)

export DRACUT_NO_XATTR=1

dracut \
  --no-hostonly \
  --kver "${KVER}" \
  --reproducible \
  --add ostree \
  -f "/lib/modules/${KVER}/initramfs.img"

chmod 0600 "/lib/modules/${KVER}/initramfs.img"