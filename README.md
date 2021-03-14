## beamup

A proof-of-concept BEAM installer.

This project contains four main pieces:

1. Builder - builds OTP releases.

   - [`build_otp.sh`](scripts/build_otp.sh) script

   - [`build_otp.yml`](.github/workflows/build_otp.yml) workflow that is triggered by an [`workflow_dispatch`](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_dispatch) event. (It can be triggered manually from GitHub UI or automatically by the `sync_otp_releases.yml` workflow below.)

     This workflow checks if a given release exists (see "Hosting" below) and if not, builds it using `scripts/build_otp.sh` and uploads it.

   - [`sync_otp_releases.yml`](.github/workflows/sync_otp_releases.yml) workflow that is running once an hour, syncing [`erlang/otp`](https://github.com/erlang/otp/releases) and [`wojtekmach/otp_releases`](https://github.com/wojtekmach/otp_releases/releases) releases and triggering release building.

2. Hosting - a place where release tarballs are stored.

   Currently we use a separate GitHub repository that just holds releases so that we can upload
   asserts. Eventually we hope to simply use <https://github.com/erlang/otp/releases>.

   See: <https://github.com/wojtekmach/otp_releases/releases>

3. Installer - installs OTP releases hosted by beamup.

   To install OTP 23.2.7 for your operating system, execute:

   ```
   $ curl https://raw.githubusercontent.com/wojtekmach/beamup2/master/install.sh | bash -s 23.2.7
   ```

4. `setup-beam` - installs OTP releases hosted by beamup into GitHub Actions.

   Example:

   ```yaml
   - uses: wojtekmach/beamup2/setup-beam@master
     with:
       otp-version: 24.0-rc1
   - run: erl -eval 'halt().'
   ```

## Notes

```
# test
./test/test.sh workflow_dispatch -e <(echo '{"inputs":{"version":"23.2.7"}}') -r

# trigger workflow dispatch
gh api -XPOST repos/wojtekmach/beamup2/actions/workflows/build_otp.yml/dispatches \
  --input <(echo '{"ref":"master","inputs":{"version":"23.2.7"}}')

# build release tarball locally and upload it
version=23.2.7; \
  release=otp-${version}-$(uname -sm | tr '[:upper:]' '[:lower:]' | tr ' ' '-').tar.gz; \
  time ./scripts/build_otp.sh $version && \
  gh release upload -R wojtekmach/otp_releases OTP-$version $TMPDIR/beamup/$release.tar.gz
```
