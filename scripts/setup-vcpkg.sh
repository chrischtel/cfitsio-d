#!/bin/bash
set -e

VCPKG_ROOT="$HOME/vcpkg"
CFITSIO_TRIPLET="x64-windows"

if [ ! -d "$VCPKG_ROOT" ]; then
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_ROOT"
    "$VCPKG_ROOT/bootstrap-vcpkg.sh"
fi

"$VCPKG_ROOT/vcpkg" install cfitsio:$CFITSIO_TRIPLET

echo "vcpkg and cfitsio installed."
