#!/bin/bash
set -e

version=$1

if [ -z "${version}" ]; then
  echo "usage: setup_otp OTP_VERSION"
  exit 1
fi

curl https://raw.githubusercontent.com/wojtekmach/beamup2/master/install.sh | bash -s $version
