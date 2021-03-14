#!/bin/bash
set -e
version=$1

if [ -z "${version}" ]; then
  echo "usage: setup_otp OTP_VERSION"
  exit 1
fi

echo "using OTP ${version}"
