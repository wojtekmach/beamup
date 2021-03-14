#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: upload.sh USER/REPO TAG PATH"
    echo
    echo "Examples:"
    echo "  upload.sh wojtekmach/otp_releases OTP-24.0-rc1 /path/to/otp-24.0-rc1-darwin-arm64.tar.gz"
    exit 1
fi

repo=$1
tag=$2
path=$3
shift
shift
shift
gh release upload -R $repo $tag $path $@
