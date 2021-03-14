#!/bin/bash
set -e
otp_version=$1

if [ -z "${otp_version}" ]; then
  echo "usage: setup_otp OTP_VERSION"
  exit
fi

echo "using OTP ${otp_version}"

curl --version
