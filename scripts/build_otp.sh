#!/bin/bash
set -e
version=$1

if [ -z "${version}" ]; then
  echo "usage: build_otp OTP_VERSION"
  exit
fi

echo "building OTP ${otp_version}"

mkdir -p tmp
cd tmp

if [ ! -d otp_src_${version} ]; then
  curl --fail -LO https://github.com/erlang/otp/releases/download/OTP-${version}/otp_src_${version}.tar.gz
  tar xzf otp_src_${version}.tar.gz
fi

cd otp_src_${version}
ls -la
