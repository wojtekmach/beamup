#!/bin/bash

tags() {
  repo=$1
  gh api repos/$repo/releases --paginate | jq -r '.[].tag_name'
}

my_tags=$(tags wojtekmach/otp_releases)
otp_tags=$(
  tags erlang/otp | \
    # OTP 23.2.7+ or 24
    grep -e OTP-23.2 -e OTP-24 | \
    grep -E -v -e "OTP-23.2$" -e "OTP-23.2.[1-6]"
)

for i in $otp_tags; do
  if [[ "$my_tags" == *"$i"* ]]; then
    echo release $i already exists
  else
    echo "syncing $i"
    echo '{"ref":"master","inputs":{"tag":"'${i}'"}}' | \
    gh api -XPOST /repos/wojtekmach/beamup2/actions/workflows/build_otp.yml/dispatches --input - 
  fi
done
