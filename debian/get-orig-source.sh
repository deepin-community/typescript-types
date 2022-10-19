#!/bin/sh
set -e

PKG=typescript-types
VER=$(date +'%Y%m%d')

packages="
backbone
"

rm -rf dl "$PKG-$VER"
mkdir -p dl
cd dl

for p in $packages; do
	echo >&2 -n "downloading $p"
	version=$(wget -q -O - "https://registry.npmjs.org/-/package/@types%2F${p}/dist-tags" | \
	python3 -m json.tool | \
	sed -ne 's/.*"latest": "\(.*\)".*/\1/gp')
	echo " $version"
	wget -qO- "https://registry.npmjs.org/@types/$p/-/$p-${version}.tgz" | tar -xzf-
	printf "%-40s%s\n" "@types/$p" "$version" >> packages.list
done

cd ..

mv dl "$PKG-$VER"
tar --sort=name \
    --owner=root --group=root \
    -cJf "${PKG}_${VER}.orig.tar.xz" "$PKG-$VER"
rm -rf "$PKG-$VER"
