SUMMARY = "initramfs for booting btrup images"
LICENSE = "MIT"

PACKAGE_INSTALL = " \
    ${VIRTUAL-RUNTIME_base-utils} \
    base-passwd \
    ${ROOTFS_BOOTSTRAP_INSTALL} \
    initramfs-btrup \
"

# Do not pollute the initramfs with rootfs features
IMAGE_FEATURES = ""

IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image
