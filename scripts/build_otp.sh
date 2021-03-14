#!/bin/bash

# Builds a given OTP version. On success, prints to stdout an absolute path to the generated
# release tarball.

set -e
version=$1

if [ -z "${version}" ]; then
  echo "usage: build_otp OTP_VERSION"
  exit 1
fi

OTP_BUILD_FLAGS="--without-jinterface"

echo "building OTP ${version}" 1>&2

mkdir -p tmp
cd tmp

if [ ! -f otp_src_${version}.tar.gz ]; then
  url=https://github.com/erlang/otp/releases/download/OTP-${version}/otp_src_${version}.tar.gz
  curl --fail -LO $url 1>&2
fi

if [ ! -d otp_src_${version} ]; then
  tar xzf otp_src_${version}.tar.gz
  cd otp_src_${version}
  export ERL_TOP=$PWD
  ./otp_build setup -a $OTP_BUILD_FLAGS 1>&2
  cd ..
fi

cd otp_src_${version}
export ERL_TOP=$PWD
release=$(echo otp-${version}-$(uname -s)-$(uname -m) | tr '[:upper:]' '[:lower:]')
export RELEASE_ROOT=$PWD/${release}
make release -j$(getconf _NPROCESSORS_ONLN) 1>&2

# TODO: disabling for now as it unnecessarily regenerates chunks, we already have them from the
# pre-compiled source!
# make release_docs -j$(getconf _NPROCESSORS_ONLN) DOC_TARGETS="chunks"

tar czf ${release}.tar.gz ${release}
echo $PWD/${release}.tar.gz
