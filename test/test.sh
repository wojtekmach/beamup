#!/bin/bash
set -e

docker build test/ -f test/ubuntu-16.04.dockerfile -t ubuntu-16.04:latest

# Setup:
# # install https://cli.github.com
# cd ..
# gh repo clone nektos/act 
# gh pr checkout 514
# go build

../act/act -P ubuntu-16.04=ubuntu-16.04:latest $@
