#!/bin/bash

tags() {
  repo=$1
  gh api repos/$repo/releases --paginate | jq -r '.[].tag_name'
}

my_tags=$(tags wojtekmach/otp_releases)
otp_tags=$(
  tags erlang/otp | \
    # OTP 23.2.6+, 23.3+, or 24
    grep -e OTP-23.2 -e OTP-23.3 -e OTP-24 | \
    grep -E -v -e "OTP-23.2$" -e "OTP-23.2.[1-5]"
)

for i in $otp_tags; do
  if [[ "$my_tags" == *"$i"* ]]; then
    echo release $i already exists
  else
    echo "syncing $i"
    gh api -XPOST repos/wojtekmach/beamup/actions/workflows/build_otp.yml/dispatches \
      --input <(echo '{"ref":"master","inputs":{"version":"'${i/OTP-/}'"}}')
  fi
done
