#!/bin/bash

set -e

[[ -d node_modules ]] || docker run --rm -t -u $(id -u) --volume $PWD:/antora:Z --env HOME=/antora antora/antora:3.1.10 npm i @antora/lunr-extension

# Only generating English
for lang in en; do
  echo "======= Generating $lang ======="
  rm -Rf output/$lang
  docker run -u $(id -u) -e CI=true -e env=local -e date="$(date '+%Y-%m-%d %H:%M:%S %Z')" -v $PWD:/antora:Z --rm -t antora/antora:3.1.10 warmaster-playbook-en.yml --attribute env=local
done
echo
