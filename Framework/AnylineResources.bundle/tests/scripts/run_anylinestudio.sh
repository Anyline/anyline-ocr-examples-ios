#!/bin/bash

set -aux -o pipefail

SCRIPT=$1
MARATHON=$2
ASSETS=$3
OUT_NAME=$4
CLI_PATH=$5

mkdir -p `dirname $OUT_NAME`

anylinestudio applyAlc --script "$SCRIPT" --mar "$MARATHON" -a "$ASSETS" --outputJson $OUT_NAME --anylinecli "$CLI_PATH"