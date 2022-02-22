#!/usr/bin/env bash

set -eu

if [ $# -eq 0 ]; then
    echo "Testbench base filename expected as first argument"
    exit 1
fi

BASE=${1}
echo "Testing ${BASE}.v"

if [ ! -f ${BASE}.v ]; then
    echo "Base verilog file not found!"
    exit 1
fi

iverilog -o "${BASE}.vvp" "${BASE}.v"
vvp "${BASE}.vvp"
gtkwave "${BASE}.vcd"