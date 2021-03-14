## Notes

```
# test
./test/test.sh workflow_dispatch -e <(echo '{"inputs":{"version":"23.2.7"}}') -r

# trigger workflow dispatch
gh api -XPOST repos/wojtekmach/beamup2/actions/workflows/build_otp.yml/dispatches \
  --input <(echo '{"ref":"master","inputs":{"version":"23.2.7"}}')

# build release tarball locally and upload it
version=23.2.7; \
  release=$(echo otp-${version}-$(uname -s)-$(uname -m) | tr '[:upper:]' '[:lower:]'); \
  time ./scripts/build_otp.sh $version && \
  gh release upload -R wojtekmach/otp_releases OTP-$version $TMPDIR/beamup/$release.tar.gz
```
