# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Firmware for ZyDAS ZD1211 USB-WLAN devices supported by the zd1211rw driver"
HOMEPAGE="https://sourceforge.net/projects/zd1211/"
SRC_URI="https://downloads.sourceforge.net/project/zd1211/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

S="${WORKDIR}"/${PN}

src_install() {
	insinto /lib/firmware/zd1211
	doins zd1211_u{b,r,phr} zd1211b_u{b,r,phr}
	dodoc README
}
