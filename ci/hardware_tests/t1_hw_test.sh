#!/usr/bin/env bash

function finish {
  ./record_video.sh ${CI_COMMIT_SHORT_SHA} stop
  ls -l *.mp4
}
trap finish EXIT

set -e # exit on nonzero exitcode
set -x # trace commands


./record_video.sh ${CI_COMMIT_SHORT_SHA} start
(cd ../.. && poetry install)
poetry run trezorctl -v list
export TREZOR_PATH=$(./get_trezor_path.sh 'Trezor 1')
echo $TREZOR_PATH
poetry run python bootstrap.py t1
poetry run python bootstrap.py t1 ../../trezor-*.bin
poetry run pytest ../../tests/device_tests
