#!/bin/bash
set -e

version=$1

if [ -z "${version}" ]; then
  echo "usage: setup_otp OTP_VERSION"
  exit 1
fi

bash install.sh $version
