#!/usr/bin/env sh

set -e

cd $(dirname "$0")/..

run_sim() {
  echo "::group::Test $1"
  cd "$1"/sim/vhdl
  $MAKE sim
  cd ../../..
  echo '::endgroup::'
}

for item in aes cbcdes cbcmac_des cbctdes des tdes; do
  run_sim $item
done
