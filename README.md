## beamup

A proof-of-concept BEAM installer.

## Components

This project contains four main components:

### 1. Builder - builds OTP releases

- [`build_otp.sh`](scripts/build_otp.sh) script

- [`build_otp.yml`](.github/workflows/build_otp.yml) workflow that is triggered by an [`workflow_dispatch`](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_dispatch) event. (It can be triggered manually from GitHub UI or automatically by the `sync_otp_releases.yml` workflow below.)

  This workflow checks if a given release exists (see "Hosting" below) and if not, builds it using `scripts/build_otp.sh` and uploads it.

- [`sync_otp_releases.yml`](.github/workflows/sync_otp_releases.yml) workflow that is running once an hour, syncing [`erlang/otp`](https://github.com/erlang/otp/releases) and [`wojtekmach/otp_releases`](https://github.com/wojtekmach/otp_releases/releases) releases and triggering release building.

`build_otp.yml` uses the `ubuntu-16.04` and `macos-10.15` GitHub Actions runners so that we build releases for the `linux-x86_64` and `darwin-x86_64` targets. I've additionally built locally and uploaded releases for `linux-aarch64` and `darwin-arm64`.

### 2. Hosting - on GitHub releases

Currently we use a separate GitHub repository that just holds releases so that we can upload
assets. Eventually we hope to simply use <https://github.com/erlang/otp/releases>.

See: <https://github.com/wojtekmach/otp_releases/releases>

### 3. Installer - installs releases

Example:

```
$ export OTP_VERSION=23.2.7 ELIXIR_VERSION=1.11.3 GLEAM_VERSION=0.14.2 && \
   curl https://raw.githubusercontent.com/wojtekmach/beamup/master/install.sh | bash
$ export PATH=$HOME/.local/share/beamup/bin:$PATH
$ elixir --version
Erlang/OTP 23 [erts-11.1.8] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

Elixir 1.11.3 (compiled with Erlang/OTP 21)
$ gleam --version
gleam 0.14.2
```

See [`install.sh`](install.sh).

We download pre-compiled binaries from:

- for OTP: <https://github.com/wojtekmach/otp_releases/releases> (including the latest Rebar3 from <http://rebar3.org>)
- for Elixir: <https://github.com/elixir-lang/elixir/releases>
- for Gleam: <https://github.com/gleam-lang/gleam/releases>

Example with Docker:

```
$ docker run --rm -it ubuntu bash

docker$ apt update && apt install -y curl unzip && export LANG=C.UTF-8

docker$ export OTP_VERSION=23.2.7 ELIXIR_VERSION=1.11.3 && \
         curl https://raw.githubusercontent.com/wojtekmach/beamup/master/install.sh | bash

docker$ elixir --version
Erlang/OTP 23 [erts-11.1.8] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1]

Elixir 1.11.3 (compiled with Erlang/OTP 21)
```

### 4. `setup-beam` - installs BEAM languages on GitHub actions

Example:

```yaml
- uses: wojtekmach/beamup/setup-beam@master
  with:
    otp-version: 24.0-rc1
    elixir-version: 1.11.3
    gleam-version: 0.14.2
- run: elixir --version
```

## Notes

```
# test
./test/test.sh workflow_dispatch -e <(echo '{"inputs":{"version":"23.2.7"}}') -r

# trigger workflow dispatch
gh api -XPOST repos/wojtekmach/beamup/actions/workflows/build_otp.yml/dispatches \
  --input <(echo '{"ref":"master","inputs":{"version":"23.2.7"}}')

# build release tarball locally and upload it
version=23.2.7; \
  release=otp-${version}-$(uname -sm | tr '[:upper:]' '[:lower:]' | tr ' ' '-').tar.gz; \
  time ./scripts/build_otp.sh $version && \
  gh release upload -R wojtekmach/otp_releases OTP-$version $TMPDIR/beamup/$release.tar.gz
```

## License

Copyright (c) 2021 Wojtek Mach

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
