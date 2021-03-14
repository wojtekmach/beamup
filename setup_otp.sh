#!/bin/bash
set -e
otp_version=$1

if [ -z "${otp_version}" ]; then
  echo "usage: setup_otp OTP_VERSION"
  exit 1
fi

echo "using OTP ${otp_version}"

curl --help
