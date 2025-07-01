#!/bin/bash

set -e

[[ -d node_modules ]] || docker run --rm -t -u $(id -u) --volume $PWD:/antora:Z --env HOME=/antora antora/antora:3.1.10 npm i @antora/lunr-extension

for lang in en; do
  echo "======= Generating $lang ======="
  rm -Rf output/$lang
  docker run -u $(id -u) -e CI=true -e env=local -e date="$(date '+%Y-%m-%d %H:%M:%S %Z')" -v $PWD:/antora:Z --rm -t antora/antora:3.1.10 antora-playbook.yml --attribute env=local
done
echo

for lang in fr; do
  echo "======= Generating $lang ======="
  rm -Rf output/$lang
  docker run -u $(id -u) -e CI=true -e env=local -e date="$(date '+%Y-%m-%d %H:%M:%S %Z')" -v $PWD:/antora:Z --rm -t antora/antora:3.1.10 antora-playbook_$lang.yml --attribute env=local
done
echo

# Disable the functions in 03-fragment-jumper.js by breaking their event listeners.
# At some point we will need to make a UI fork without this function,
# or maybe it will be removed: https://gitlab.com/antora/antora-ui-default/-/issues/194
sed -i 's/a\[href^="#"\]/DISABLEDXXXX/' output/*/_/js/site.js
sed -i 's/window.addEventListener."load",function l.e./window.addEventListener("DSBL",function l(e)/' output/*/_/js/site.js
