# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/SFML"
SRC_URI="https://github.com/SFML/SFML/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SFML-${PV}"

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="debug doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/flac:=
	media-libs/freetype:2
	media-libs/libjpeg-turbo:=
	media-libs/libogg
	media-libs/libpng:=
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libXi
	x11-libs/xcb-util-image
	kernel_linux? ( virtual/libudev:= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	doc? ( app-text/doxygen )
	test? ( >=dev-cpp/catch-3.7.0 )
"

DOCS=( changelog.md readme.md )

PATCHES=( "$FILESDIR"/"${PN}"-3.0.0-catch-depend.patch )

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die

	find examples -name CMakeLists.txt -delete || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSFML_BUILD_DOC=$(usex doc)
		-DSFML_INSTALL_PKGCONFIG_FILES=TRUE
		-DSFML_BUILD_TEST_SUITE=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# broken in sandbox
	local CMAKE_SKIP_TESTS=(
		sf::Clipboard
		sf::Context
		sf::Cursor
		sf::Keyboard
		sf::VideoMode
		sf::Window
		sf::Drawable
		sf::Font
		sf::RenderTexture
		sf::RenderWindow
		sf::Shader
		sf::Shape
		sf::Sprite
		sf::Text
		sf::Texture
		sf::IpAddress
		sf::Sound
		sf::SoundStream
		Render Tests
	)
	cmake_src_test
}

src_install() {
	cmake_src_install

	insinto /usr/share/cmake/Modules
	doins cmake/SFMLConfig.cmake.in

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
