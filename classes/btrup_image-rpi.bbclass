inherit image_types

KERNEL_IMG_raspberrypi ?= "kernel.img"
KERNEL_IMG_raspberrypi2 ?= "kernel7.img"
KERNEL_IMG_raspberrypi3-64 ?= "kernel8.img"


def split_overlays(d, out, ver=None):
    dts = d.getVar("KERNEL_DEVICETREE")
    # Device Tree Overlays are assumed to be suffixed by .dtbo and are put
    # in a dedicated folder
    if out:
        overlays = oe.utils.str_filter_out('\S+\.dtbo$', overlays, d)
    else:
        overlays = oe.utils.str_filter('\S+\.dtbo$', dts, d)
    return overlays


IMAGE_CMD:btrup() {
    rm -rf ${WORKDIR}/btrup
    
    cp -a ${IMAGE_ROOTFS} ${WORKDIR}/btrup
    cp -a ${DEPLOY_DIR_IMAGE}/${BOOTFILES_DIR_NAME} ${WORKDIR}/btrup/usr/lib/btrup/boot
    
    # Check if we are building with device tree support
    DTS="${KERNEL_DEVICETREE}"

    if [ -n "${DTS}" ]; then
        # Copy board device trees
        for dtbf in ${@split_overlays(d, True)}; do
            dtb="$(basename $dtbf)"
            cp ${DEPLOY_DIR_IMAGE}/$dtb ${WORKDIR}/btrup/usr/lib/btrup/boot
        done

        # Copy device tree overlays
        install -d ${WORKDIR}/btrup//usr/lib/btrup/boot/overlays
        for dtbf in ${@split_overlays(d, False)}; do
            dtb="$(basename $dtbf)"
            cp ${DEPLOY_DIR_IMAGE}/$dtb ${WORKDIR}/btrup/usr/lib/btrup/boot/overlays
        done
    fi

    # Copy kernel/initramfs
    if [ ! -z "${INITRAMFS_IMAGE}" ] && [ "${INITRAMFS_IMAGE_BUNDLE}" = "1" ]; then
        cp ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${INITRAMFS_LINK_NAME}.bin ${WORKDIR}/btrup/usr/lib/btrup/boot/${KERNEL_IMG}
    else
        cp ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} ${WORKDIR}/btrup/usr/lib/btrup/boot/${KERNEL_IMG}
    fi

    tar --sort=name --format=posix --numeric-owner -I zstd -cf ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.btrup -C ${WORKDIR}/btrup .
}
do_image_btrup[depends] += "virtual/kernel:do_deploy"
do_image_btrup[depends] += "zstd-native:do_populate_sysroot"
