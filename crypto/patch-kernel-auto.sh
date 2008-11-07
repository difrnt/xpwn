#!/bin/bash
XPWNTOOL=./xpwntool
PATCHKERNEL=./patch-kernel-crypto
KERNEL=/System/Library/Caches/com.apple.kernelcaches/kernelcache.s5l8900x

NONCE=`./xpwntool ${KERNEL} /dev/null | grep -v match | tr -cd [:alnum:] | sed 's/0x//g'`
KEYIV=`./aes dec GID $NONCE`
IV=`echo $KEYIV | sed 's/\([a-z0-9]\{32\}\).*/\\1/'`
KEY=`echo $KEYIV | sed 's/[a-z0-9]\{32\}//'`

${XPWNTOOL} ${KERNEL} /tmp/a -iv ${IV} -k ${KEY}
${PATCHKERNEL} /tmp/a
${XPWNTOOL} /tmp/a /tmp/b -t ${KERNEL} -iv ${IV} -k ${KEY}
rm /tmp/a
cp ${KERNEL} /kernel.backup
cp /tmp/b ${KERNEL}
rm /tmp/b

