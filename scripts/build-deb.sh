#!/bin/bash
#
# This work is copyright 2011 - 2013 Jordon Mears. All rights reserved.
#
# This file is part of Cider.
#
# Cider is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Cider is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Cider. If not, see <http://www.gnu.org/licenses/>.

cd `dirname $0`/..

find . -name "*.pyc" -exec rm '{}' ';'

VERSION=`cat version.txt | sed -e 's/\n//g'`
BINARY_TARGET="cider-$VERSION-bin"
TARGET="cider-$VERSION"

rm -rf build

BUILD_TARGET="build/$TARGET"

./scripts/build-bin.sh

cp -r build/$BINARY_TARGET $BUILD_TARGET
cp dist/$BINARY_TARGET.tar.gz $BUILD_TARGET/$TARGET.tar.gz
cd $BUILD_TARGET
dh_make --s -e jordoncm@gmail.com -c GPL -f $TARGET.tar.gz
cd ..
rm -f cider_$VERSION.orig.tar.gz

mkdir -p $TARGET/extra
cd $TARGET/extra
ln -s /usr/share/cider/configuration.json cider.json
ln -s /usr/share/cider/cider cider
cd ../..
cp ../scripts/deb/control $TARGET/debian/
cp ../scripts/deb/cider.install $TARGET/debian/
cd $TARGET/debian/
rm -f *ex
rm -f *EX
rm -f README*
rm -rf source
cd ..
dpkg-buildpackage -b
cd ..

mv cider_$VERSION-1_all.deb ../dist/
