#!/bin/bash

# Setup:
# # install https://cli.github.com
# cd ..
# gh repo clone nektos/act 
# gh pr checkout 514
# go build

../act/act -P ubuntu-latest=node:12.21.0-buster
