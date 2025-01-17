# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="Python scripts to manipulate trash cans via the command line"
HOMEPAGE="https://github.com/andreafrancia/trash-cli"
SRC_URI="https://github.com/andreafrancia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-lint-in-tests.patch"
	"${FILESDIR}/${P}-fix-lint-in-trash-cli.patch"
	"${FILESDIR}/${P}-fix-unit-tests-not-deleting-temp-directories.patch"
	"${FILESDIR}/${P}-fix-unit-test-test_trash_empty_will_skip_unreadable.patch"
)

distutils_enable_tests pytest

src_test() {
	local -x COLUMNS=80
	distutils-r1_src_test
}
