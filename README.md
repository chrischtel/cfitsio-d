# cfitsio-d

D bindings for the [CFITSIO](https://heasarc.gsfc.nasa.gov/fitsio/) C library, which provides high-level routines for reading and writing FITS (Flexible Image Transport System) files.

---

## Features

- Direct access to the full CFITSIO C API from D
- Cross-platform: Windows, Linux, macOS
- Easy integration with DUB
- Includes a CLI installer to fetch prebuilt binaries
- Actively maintained and auto-updatable bindings

---

## Prerequisites

You **must have the native CFITSIO library and its dependencies** (e.g., zlib) available for linking and at runtime.  
This D package provides the bindings, not the C library itself.

---

## Quick Start (Recommended)

### 1. **Add as a Dependency**
> **Note:**  
> Due to a current issue, `cfitsio-d` is **not yet available on the official DUB package registry**.  
> You must add it manually to your `dub.json` or `dub.sdl` using the GitHub repository URL and a specific commit hash or branch.

In your `dub.json`:
```json
    "dependencies": {
        "cfitsio-d": {
            "version": "<commit-hash>", 
            "repository": "git+https://github.com/chrischtel/cfitsio-d.git"
        }
    },
```

**In your `dub.sdl`:**

```sdl
dependency "cfitsio-d" repository="https://github.com/chrischtel/cfitsio-d.git" version="<commit-hash>"
```


### 2. **Install the Native Library**

#### **Option A: Use the CLI Installer (Recommended for Windows, works on all platforms)**

Run the installer to download and extract the correct prebuilt binaries for your platform:

```sh
dub run cfitsio-d:install
```

**To see all options:**
```sh
dub run cfitsio-d:install -- --help
```

**Options include:**
- `--version` or `-v` to specify the CFITSIO version
- `--output` or `-o` to set the output directory
- `--force` or `-f` to force re-download
- `--no-update-dub` to skip updating `dub.json`
- `--keep-archive` or `-k` to keep the downloaded archive
- `--quiet` or `-q` for less output

The installer will:
- Download the correct binary archive for your OS/arch (and MSVC/MinGW on Windows)
- Extract `cfitsio.dll`/`.so`/`.dylib` and `zlib1.dll`/`.lib` if needed
- Optionally update your `dub.json` with the correct linker flags

#### **Option B: Install Manually**

- **Windows:**  
  - Use [vcpkg](https://vcpkg.io/) or the official [CFITSIO site](https://heasarc.gsfc.nasa.gov/fitsio/).
  - Make sure you use the correct architecture (x86_64 vs x86) and toolchain (MSVC vs MinGW).
  - Place `cfitsio.dll` and `zlib1.dll` next to your executable or in your `PATH`.
  - Place `cfitsio.lib` and `zlib.lib` in your project directory or add their location to your linker path.

- **Linux:**  
  - Install with your package manager:
    ```sh
    sudo apt install libcfitsio-dev
    # or
    sudo dnf install cfitsio-devel
    # or
    sudo pacman -S cfitsio
    ```
  - This provides `libcfitsio.so` in your system library path.

- **macOS:**  
  - Install with Homebrew:
    ```sh
    brew install cfitsio
    ```
  - This provides `libcfitsio.dylib` in your system library path.

---

## Linking and Architecture

### **DUB Configuration**

#### **Windows (MSVC):**
```json
"lflags-windows": [
    "/LIBPATH:.", // or your lib directory
    "cfitsio.lib",
    "zlib.lib"
]
```
- `/LIBPATH:.` tells the linker to look in the current directory for `.lib` files.
- Make sure your `.lib` files are built with **MSVC** if you use DMD/LDC with the MSVC toolchain.

#### **Windows (MinGW):**
```json
"lflags-windows": [
    "-L.",
    "-lcfitsio",
    "-lz"
]
```
- Only use this if you are building everything with MinGW (not recommended for DMD/LDC).

#### **Linux/macOS:**
```json
"lflags-posix": [
    "-L.",
    "-lcfitsio"
]
```
- If installed system-wide, just use `-lcfitsio`.

### **DLLs on Windows**

- Place `cfitsio.dll` and `zlib1.dll` in the same directory as your executable, or in your `PATH`.
- **MSVC vs MinGW:**  
  - MSVC `.lib` files are not compatible with MinGW, and vice versa.
  - Always match the architecture (x86_64 vs x86) and toolchain.

### **MSVC Architecture Matching**

- If you build your D project as 64-bit (`x86_64`), you must use 64-bit `cfitsio.dll`/`.lib` and `zlib1.dll`/`.lib`.
- If you build as 32-bit, use 32-bit binaries.
- Mixing 32/64-bit or MSVC/MinGW will result in linker or runtime errors.

---

## Usage Example

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

## Troubleshooting

### **Common Issues and Solutions**

- **Linker error: "invalid or corrupt file"**  
  - Your `.lib` file is not built with MSVC, or is the wrong architecture.  
  - Use the CLI installer or build CFITSIO with the correct toolchain.

- **Linker error: `/L.` not recognized**  
  - Use `/LIBPATH:.` for MSVC, not `-L.`.

- **Runtime error: `Program exited with code -1073741515` (0xC0000135)**  
  - A required DLL (`cfitsio.dll`, `zlib1.dll`, or a Visual C++ runtime DLL) is missing.
  - Place all required DLLs next to your executable or in your `PATH`.
  - Use [Dependencies](https://github.com/lucasg/Dependencies) to check for missing DLLs.

- **"library not found" on Linux/macOS**  
  - Set `LD_LIBRARY_PATH` (Linux) or `DYLD_LIBRARY_PATH` (macOS) if the library is not in a standard location.

- **Architecture mismatch**  
  - All binaries (your app, `cfitsio.dll`, `zlib1.dll`) must be either all 64-bit or all 32-bit.

- **MinGW vs MSVC**  
  - Do not mix MinGW and MSVC binaries. Use MSVC-built libraries for DMD/LDC on Windows.

---

## Advanced: Using the CLI Installer

The installer can be run with various options:

```sh
dub run cfitsio-d:install -- --help
```

**Options:**
- `--version` or `-v` — Specify CFITSIO version (default: latest)
- `--output` or `-o` — Output directory for library files
- `--force` or `-f` — Force re-download even if files exist
- `--no-update-dub` — Do not update `dub.json`
- `--keep-archive` or `-k` — Keep the downloaded archive
- `--quiet` or `-q` — Suppress non-error output
- `--proxy` — Use a proxy for downloads

The installer will:
- Download the correct binary archive for your OS/arch/toolchain
- Extract all required files (`cfitsio.dll`, `cfitsio.lib`, `zlib1.dll`, `zlib.lib`, etc.)
- Optionally update your `dub.json` with the correct linker flags

---

## Updating the Bindings

To update to a new CFITSIO version:

- coming soon...

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
- [Dependencies (DLL checker)](https://github.com/lucasg/Dependencies)

---

## FAQ

**Q: I get a linker error about `cfitsio.lib` being corrupt.**  
A: You are probably using a MinGW-built `.lib` with MSVC, or vice versa. Use the CLI installer or build with the correct toolchain.

**Q: My program runs but exits with code -1073741515.**  
A: A required DLL is missing. Use Dependencies to check, and ensure all DLLs are present and match your architecture.

**Q: How do I use the installer with custom options?**  
A:  
```sh
dub run cfitsio-d:install -- --help
```
for all options.

---

**If you have any issues, please open an issue on GitHub!**