SUMMARY = "initramfs script for btrup"
LICENSE = "GPL-3.0+"
LIC_FILES_CHKSUM = "file://init;beginline=3;endline=3;md5=eb6d9f9bdbcd341cc34277a457d9862d"
DEPENDS = ""

SRC_URI = "file://init"

inherit allarch

S = "${WORKDIR}"

do_install() {
    install -m 0755 ${S}/init ${D}
}

FILES:${PN} = "/init"
RDEPENDS:${PN} += "grep util-linux-mount"
RRECOMMENDS:${PN} += "kernel-module-btrfs"
