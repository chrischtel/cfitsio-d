module tests.test;

import fitsio;
import std.stdio;

void main() {
    fitsfile* fptr = null;
    int status = 0;
    string filename = "!test.fits\0";
    int ret = ffinit(&fptr, filename.ptr, &status);
    if (ret == 0) {
        writeln("CFITSIO: Created test.fits");
        ffclos(fptr, &status);
    } else {
        writeln("CFITSIO: Error ", status);
    }
}
