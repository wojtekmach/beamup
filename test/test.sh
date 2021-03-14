#!/bin/bash
set -e

mkdir -p tmp
for i in .github/workflows/*.yml; do
  echo "# copied from $i. do not edit manually" > tmp/$(basename $i)
  cat $i | sed s/ACTIONS_TOKEN/GITHUB_TOKEN/g >> tmp/$(basename $i)
done

docker build test/ -f test/ubuntu-16.04.dockerfile -t ubuntu-16.04:latest

# Setup:
# # install https://cli.github.com
# cd ..
# gh repo clone nektos/act 
# gh pr checkout 514
# go build

../act/act --workflows tmp -P ubuntu-16.04=ubuntu-16.04:latest $@
