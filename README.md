# cfitsio-d

D bindings for the [CFITSIO](https://heasarc.gsfc.nasa.gov/fitsio/) C library, which provides high-level routines for reading and writing FITS (Flexible Image Transport System) files.

---

## Features

- Direct access to the full CFITSIO C API from D
- Cross-platform: Windows, Linux, macOS
- Easy integration with DUB
- Actively maintained and auto-updatable bindings

---

## Prerequisites

You **must have the native CFITSIO library installed** on your system.  
This D package only provides the bindings, not the C library itself.

### **CFITSIO Installation**

#### **Windows**

- **Recommended:** Use [vcpkg](https://vcpkg.io/) to install CFITSIO:
  ```sh
  vcpkg install cfitsio
  ```
- Or, [download and build CFITSIO manually](https://heasarc.gsfc.nasa.gov/fitsio/).
- Make sure `cfitsio.lib` (and `zlib.lib` if needed) are in your `LIB` path, and `cfitsio.dll` is in your `PATH` or next to your executable.

#### **Linux**

- Install with your package manager:
  ```sh
  sudo apt install libcfitsio-dev
  # or
  sudo dnf install cfitsio-devel
  # or
  sudo pacman -S cfitsio
  ```
- This will provide `libcfitsio.so` in your system library path.

#### **macOS**

- Install with Homebrew:
  ```sh
  brew install cfitsio
  ```
- This will provide `libcfitsio.dylib` in your system library path.

---

## Linking

### **DUB Configuration**

Add the following to your `dub.json` or `dub.sdl`:

#### **For Windows (MSVC):**
```json
"lflags": [
    "cfitsio.lib"
]
```
If your library is in a local `lib/` directory:
```json
"lflags": [
    "/LIBPATH:lib",
    "cfitsio.lib"
]
```

#### **For MinGW, Linux, or macOS:**
```json
"lflags": [
    "-Llib",
    "-lcfitsio"
]
```
Or, if installed system-wide:
```json
"lflags": [
    "-lcfitsio"
]
```

### **DLLs on Windows**

If you use the DLL version, ensure `cfitsio.dll` is in your `PATH` or next to your executable at runtime.

---

## Usage

### **Add as a Dependency**

In your `dub.json`:
```json
"dependencies": {
    "cfitsio-d": "~>0.1.0"
}
```
Or in your `dub.sdl`:
```sdl
dependency "cfitsio-d" version="~>0.1.0"
```

### **Example: Create a FITS File**

```d
import cfitsio;
import std.stdio;

void main() {
    fitsfile* fptr = null;
    int status = 0;
    string filename = "!example.fits\0"; // '!' to overwrite if exists

    int ret = ffinit(&fptr, filename.ptr, &status);
    if (ret != 0) {
        writeln("Error initializing FITS file: ", status);
        return;
    }
    writeln("FITS file initialized successfully.");

    // Write a minimal primary HDU (header only, no data)
    int simple = 1;
    int bitpix = 8;
    int naxis = 0;
    int* naxes = null;
    ffphpr(fptr, simple, bitpix, naxis, naxes, 0, 1, 1, &status);

    ffclos(fptr, &status);
    if (status != 0) {
        writeln("Error closing FITS file: ", status);
        return;
    }
    writeln("FITS file closed successfully.");
}
```

---

## Updating the Bindings

To update to a new CFITSIO version:

1. Download the new `fitsio.h` and place it in the `c/` directory.
2. Run the update script:
   ```sh
   ./scripts/update_bindings.sh
   ```
3. Review and commit the changes.

---

## Troubleshooting

- **Linker errors about missing `cfitsio`**:  
  Make sure the library is installed and the linker can find it.  
  On Windows, check your `LIB` path and use the correct `lflags`.
- **Runtime errors about missing DLLs**:  
  Ensure `cfitsio.dll` is in your `PATH` or next to your executable.
- **On Linux/macOS**:  
  If you get "library not found" errors, make sure `libcfitsio.so`/`.dylib` is in a standard library path or set `LD_LIBRARY_PATH`/`DYLD_LIBRARY_PATH`.

---

## Contributing

- PRs and issues are welcome!
- Please run the update script and test on your platform before submitting changes.

---

## License

MIT (see LICENSE file)

---

## References

- [CFITSIO Home](https://heasarc.gsfc.nasa.gov/fitsio/)
- [D Language](https://dlang.org/)
- [dstep (for updating bindings)](https://github.com/jacob-carlborg/dstep)
- [vcpkg](https://vcpkg.io/)

---
