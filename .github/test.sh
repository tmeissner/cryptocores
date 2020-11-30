#!/usr/bin/env sh

set -e

cd $(dirname "$0")/..

case "$1" in
  sim)
    true
  ;;
  *)
    echo "Unknown test suite '$1'"
    exit 1
  ;;
esac

run_task() {
  echo "::group::Test $1"
  cd "$1"/"$2"/vhdl
  $MAKE "$2"
  cd ../../..
  echo '::endgroup::'
}

for item in aes cbcdes cbcmac_des cbctdes ctraes des tdes; do
  run_task "$item" "$1"
done
