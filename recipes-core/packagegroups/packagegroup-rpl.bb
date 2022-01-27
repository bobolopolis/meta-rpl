SUMMARY = "Packages to build for Red Pi Linux"

# Some packages get dynamically renamed, so this can't be allarch
PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    htop \
    openssh \
    screen \
    vim \
"
