#!/bin/bash
set -e

# Path to fitsio.h (adjust if needed)
HEADER="c/fitsio.h"
OUT="source/cfitsio.d"

# Check for dstep
if ! command -v dstep &> /dev/null; then
    echo "dstep not found! Install with: dub fetch dstep && dub run dstep -- --help"
    exit 1
fi

echo "Generating D bindings from $HEADER..."
dstep "$HEADER" -o "$OUT"

echo "Bindings updated: $OUT"
