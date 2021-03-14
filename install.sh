#!/bin/bash

set -e

if [ -z "${1}" ]; then
  echo "Usage: install.sh OTP_VERSION"
  exit 1
fi

version=$1
release=otp-${version}-$(uname -sm | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

TMPDIR="${TMPDIR:=/tmp}/beamup-install"
mkdir -p $TMPDIR
cd $TMPDIR

url=https://github.com/wojtekmach/otp_releases/releases/download/OTP-$version/$release.tar.gz
echo "downloading $url"
curl --fail -LO $url
tar xzf $release.tar.gz

root=$HOME/.local/share/beamup/installs/otp
echo "installing to $root/$version"
rm -rf $root/$version
mkdir -p $root
mv $release $root/$version
cd $root/$version
./Install -sasl $PWD

echo "Installation is complete!"
echo
echo "Add this directory to your PATH:"
echo
echo "    export PATH=$root/$version/bin:\$PATH"
echo
