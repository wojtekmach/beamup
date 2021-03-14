#!/bin/bash

set -e

main() {
  if [ -z "$OTP_VERSION" ]; then
    echo "Please set at least OTP_VERSION environment variable!"
    echo
    echo "Usage: install.sh"
    echo
    echo "Supported environment variables:"
    echo
    echo " - OTP_VERSION"
    echo " - ELIXIR_VERSION"
    exit 1
  fi

  TMPDIR="${TMPDIR:=/tmp}/beamup-install"
  mkdir -p $TMPDIR

  cd $TMPDIR
  install_otp $OTP_VERSION

  if [ -n "${ELIXIR_VERSION}" ]; then
    cd $TMPDIR
    install_elixir ${ELIXIR_VERSION}
  fi

  if [ -n "${GLEAM_VERSION}" ]; then
    cd $TMPDIR
    install_gleam ${GLEAM_VERSION}
  fi

  echo
  echo "Installation complete!"
  echo
  echo "Add this directory to your PATH:"
  echo
  echo "    export PATH=$root/bin:\$PATH"
  echo
}

install_otp() {
  version=$1
  release=otp-${version}-$(uname -sm | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  url=https://github.com/wojtekmach/otp_releases/releases/download/OTP-$version/$release.tar.gz
  echo ">> downloading $url"
  curl --fail -LO $url
  tar xzf $release.tar.gz

  root=$HOME/.local/share/beamup
  otp_root=$root/installs/otp

  echo ">> installing to $otp_root/$version"
  rm -rf $otp_root/$version
  mkdir -p $otp_root
  mv $release $otp_root/$version
  cd $otp_root/$version
  ./Install -sasl $PWD

  url=https://s3.amazonaws.com/rebar3/rebar3
  echo ">> downloading $url"
  echo ">> installing rebar3 to $otp_root/$version"
  curl --fail -L $url > $otp_root/$version/bin/rebar3
  chmod +x $otp_root/$version/bin/rebar3

  mkdir -p $root/bin
  ln -fs $otp_root/$version/bin/* $root/bin
}

install_elixir() {
  version=$1
  url=https://github.com/elixir-lang/elixir/releases/download/v$version/Precompiled.zip
  echo ">> downloading $url"
  curl --fail -LO $url
  unzip -q -d elixir-$version Precompiled.zip

  root=$HOME/.local/share/beamup
  elixir_root=$root/installs/elixir

  echo ">> installing to $elixir_root/$version"
  rm -rf $elixir_root/$version
  mkdir -p $elixir_root
  mv elixir-$version $elixir_root/$version
  mkdir -p $root/bin
  ln -fs $elixir_root/$version/bin/* $root/bin
}

install_gleam() {
  version=$1
  case $(uname -s) in
    # TODO: $(uname -sm | tr '[:upper:]' '[:lower:]' | tr ' ' '-') or something should do the trick
    # we need to fix https://github.com/gleam-lang/gleam/blob/v0.14.2/.github/workflows/release.yaml#L29
    "Linux")
      extra=linux-amd64
      ;;
    "Darwin")
      extra=macos
      ;;

    *)
      echo $(uname -s) is not supported
      exit 1
      ;;
  esac
  release=gleam-v$version-$extra
  url=https://github.com/gleam-lang/gleam/releases/download/v$version/$release.tar.gz
  echo ">> downloading $url"
  curl --fail -LO $url
  tar xzf $release.tar.gz

  root=$HOME/.local/share/beamup
  gleam_root=$root/installs/gleam

  echo ">> installing to $gleam_root/$version"
  rm -rf $gleam_root/$version
  mkdir -p $gleam_root/$version
  mv gleam $gleam_root/$version
  mkdir -p $root/bin
  ln -fs $gleam_root/$version/gleam $root/bin/
}

main
