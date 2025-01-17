# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop udev unpacker xdg-utils

DESCRIPTION="A modern and intuitive control software for the Batronix USB programming devices"
HOMEPAGE="https://www.batronix.com"
SRC_URI="
	amd64? ( https://www.batronix.com/exe/Batronix/Prog-Express/deb/${P}-1.amd64.deb )
	x86? ( https://www.batronix.com/exe/Batronix/Prog-Express/deb/${P}-1.i386.deb )
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="prog-express"
SLOT="0"

RDEPEND="
	dev-db/sqlite:3
	dev-dotnet/libgdiplus
	dev-lang/mono
	dev-lang/mono-basic
	virtual/libusb:1
	virtual/udev
"

DOCS=(
	"usr/share/doc/prog-express/changelog"
	"usr/share/doc/prog-express/manuals"
)

QA_PREBUILT="
	usr/bin/bxusb
	usr/bin/bxusb-gui
	usr/bin/prog-express
	usr/sbin/bxfxload
"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	gunzip usr/share/doc/prog-express/changelog.gz usr/share/man/man1/*.gz || die
}

src_install() {
	dobin usr/bin/{bxusb,bxusb-gui,prog-express}
	dosbin usr/sbin/bxfxload

	insinto /usr/lib
	doins -r usr/lib/bxusb usr/lib/prog-express

	insinto /usr/lib/prog-express
	doins "${FILESDIR}"/pe.exe.config

	udev_dorules lib/udev/rules.d/85-batronix-devices.rules

	doicon usr/share/pixmaps/prog-express.png

	domenu usr/share/applications/prog-express.desktop

	doman usr/share/man/man1/{bxfxload,bxusb,bxusb-gui,prog-express}.1
}

pkg_postinst() {
	udev_reload
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	udev_reload
	xdg_desktop_database_update
	xdg_icon_cache_update
}
