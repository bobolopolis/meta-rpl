SUMMARY = "btrfs based firmware upgrade"
LICENSE = "GPL-3.0+"
LIC_FILES_CHKSUM = "file://btrup;beginline=3;endline=3;md5=eb6d9f9bdbcd341cc34277a457d9862d"

SRC_URI = "file://btrup"

S = "${WORKDIR}"

inherit allarch

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/btrup ${D}${bindir}

    # Don't use variables since this path is hardcoded in disk programmer
    # and btrup
    install -d ${D}/usr/lib/btrup
}
FILES:${PN} += "/usr/lib/btrup"
RDEPENDS:${PN} = " \
    btrfs-tools \
    tar \
    util-linux-mount \
    zstd \
"
