/*  The FITSIO software was written by William Pence at the High Energy    */
/*  Astrophysic Science Archive Research Center (HEASARC) at the NASA      */
/*  Goddard Space Flight Center.                                           */
/*

Copyright (Unpublished--all rights reserved under the copyright laws of
the United States), U.S. Government as represented by the Administrator
of the National Aeronautics and Space Administration.  No copyright is
claimed in the United States under Title 17, U.S. Code.

Permission to freely use, copy, modify, and distribute this software
and its documentation without fee is hereby granted, provided that this
copyright notice and disclaimer of warranty appears in all copies.

DISCLAIMER:

THE SOFTWARE IS PROVIDED 'AS IS' WITHOUT ANY WARRANTY OF ANY KIND,
EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED TO,
ANY WARRANTY THAT THE SOFTWARE WILL CONFORM TO SPECIFICATIONS, ANY
IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, AND FREEDOM FROM INFRINGEMENT, AND ANY WARRANTY THAT THE
DOCUMENTATION WILL CONFORM TO THE SOFTWARE, OR ANY WARRANTY THAT THE
SOFTWARE WILL BE ERROR FREE.  IN NO EVENT SHALL NASA BE LIABLE FOR ANY
DAMAGES, INCLUDING, BUT NOT LIMITED TO, DIRECT, INDIRECT, SPECIAL OR
CONSEQUENTIAL DAMAGES, ARISING OUT OF, RESULTING FROM, OR IN ANY WAY
CONNECTED WITH THIS SOFTWARE, WHETHER OR NOT BASED UPON WARRANTY,
CONTRACT, TORT , OR OTHERWISE, WHETHER OR NOT INJURY WAS SUSTAINED BY
PERSONS OR PROPERTY OR OTHERWISE, AND WHETHER OR NOT LOSS WAS SUSTAINED
FROM, OR AROSE OUT OF THE RESULTS OF, OR USE OF, THE SOFTWARE OR
SERVICES PROVIDED HEREUNDER."

*/

extern (C):


import core.stdc.config;
import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.stdint; // At the top of your file

/* Minor and micro numbers must not exceed 99 under current method
   of version representataion in ffvers(). */
enum CFITSIO_MICRO = 2;
enum CFITSIO_MINOR = 6;
enum CFITSIO_MAJOR = 4;
enum CFITSIO_SONAME = 10;

/* the SONAME is incremented in a new release if the binary shared */
/* library (on linux and Mac systems) is not backward compatible */
/* with the previous release of CFITSIO */

/* CFITS_API is defined below for use on Windows systems.  */
/* It is used to identify the public functions which should be exported. */
/* This has no effect on non-windows platforms where "WIN32" is not defined */

/* __declspec(dllimport) */
/* CFITS_API */
/* defined (WIN32) */

/* the following was provided by Michael Greason (GSFC) to fix a */
/*  C/Fortran compatibility problem on an SGI Altix system running */
/*  SGI ProPack 4 [this is a Novell SuSE Enterprise 9 derivative]  */
/*  and using the Intel C++ and Fortran compilers (version 9.1)  */

/* apparently needed on debian linux systems */
/* to define off_t                           */

/* apparently needed to define size_t with gcc 2.8.1 */
/* needed for LLONG_MAX and INT64_MAX definitions */

/* Define the datatype for variables which store file offset values. */
/* The newer 'off_t' datatype should be used for this purpose, but some */
/* older compilers do not recognize this type, in which case we use 'long' */
/* instead.  Note that _OFF_T is defined (or not) in stdio.h depending */
/* on whether _LARGEFILE_SOURCE is defined in sys/feature_tests.h  */
/* (at least on Solaris platforms using cc)  */

/*  Debian systems require: "(defined(__GLIBC__) && defined(__off_t_defined))" */
/*  the mingw-w64 compiler requires: "(defined(__MINGW32__) && defined(_OFF_T_DEFINED))" */

alias OFF_T = long;

/* this block determines if the the string function name is
    strtol or strtoll, and whether to use %ld or %lld in printf statements */

/*
   The following 2 cases for that Athon64 were removed on 4 Jan 2006;
   they appear to be incorrect now that LONGLONG is always typedef'ed
   to 'long long'
    ||  defined(__ia64__)   \
    ||  defined(__x86_64__) \
*/

enum USE_LL_SUFFIX = 0;

/*
   Determine what 8-byte integer data type is available.
  'long long' is now supported by most compilers, but
  older MS Visual C++ compilers before V7.0 use '__int64' instead.
*/

/* this may have been previously defined */ /* Microsoft Visual C++ */ /* versions earlier than V7.0 do not have 'long long' */

/* newer versions do support 'long long' */
alias LONGLONG = long;
alias ULONGLONG = ulong;

/* for the Borland 5.5 compiler, in particular */

/* Linux and Solaris definition */
enum LONGLONG_MAX = long.max;
enum LONGLONG_MIN = long.min;

/* Mac OS X & CYGWIN defintion */

/* windows definition */

/* windows definition */

/* sizeof(long) = 64 */
/* max 64-bit integer */
/* min 64-bit integer */

/*  define a default value, even if it is never used */
/* max 64-bit integer */
/* min 64-bit integer */

/* end of ndef LONGLONG_MAX section */

/* ================================================================= */

/*  The following exclusion if __CINT__ is defined is needed for ROOT */

enum NIOBUF = 40; /* number of IO buffers to create (default = 40) */
/* !! Significantly increasing NIOBUF may degrade performance !! */

enum IOBUFLEN = 2880; /* size in bytes of each IO buffer (DONT CHANGE!) */

/* global variables */

enum FLEN_FILENAME = 1025; /* max length of a filename  */
enum FLEN_KEYWORD = 75; /* max length of a keyword (HIERARCH convention) */
enum FLEN_CARD = 81; /* length of a FITS header card */
enum FLEN_VALUE = 71; /* max length of a keyword value string */
enum FLEN_COMMENT = 73; /* max length of a keyword comment string */
enum FLEN_ERRMSG = 81; /* max length of a FITSIO error message */
enum FLEN_STATUS = 31; /* max length of a FITSIO status text string */

enum TBIT = 1; /* codes for FITS table data types */
enum TBYTE = 11;
enum TSBYTE = 12;
enum TLOGICAL = 14;
enum TSTRING = 16;
enum TUSHORT = 20;
enum TSHORT = 21;
enum TUINT = 30;
enum TINT = 31;
enum TULONG = 40;
enum TLONG = 41;
enum TINT32BIT = 41; /* used when returning datatype of a column */
enum TFLOAT = 42;
enum TULONGLONG = 80;
enum TLONGLONG = 81;
enum TDOUBLE = 82;
enum TCOMPLEX = 83;
enum TDBLCOMPLEX = 163;

enum TYP_STRUC_KEY = 10;
enum TYP_CMPRS_KEY = 20;
enum TYP_SCAL_KEY = 30;
enum TYP_NULL_KEY = 40;
enum TYP_DIM_KEY = 50;
enum TYP_RANG_KEY = 60;
enum TYP_UNIT_KEY = 70;
enum TYP_DISP_KEY = 80;
enum TYP_HDUID_KEY = 90;
enum TYP_CKSUM_KEY = 100;
enum TYP_WCS_KEY = 110;
enum TYP_REFSYS_KEY = 120;
enum TYP_COMM_KEY = 130;
enum TYP_CONT_KEY = 140;
enum TYP_USER_KEY = 150;

alias INT32BIT = int; /* 32-bit integer datatype.  Currently this       */
/* datatype is an 'int' on all useful platforms   */
/* however, it is possible that that are cases    */
/* where 'int' is a 2-byte integer, in which case */
/* INT32BIT would need to be defined as 'long'.   */

enum BYTE_IMG = 8; /* BITPIX code values for FITS image types */
enum SHORT_IMG = 16;
enum LONG_IMG = 32;
enum LONGLONG_IMG = 64;
enum FLOAT_IMG = -32;
enum DOUBLE_IMG = -64;
/* The following 2 codes are not true FITS         */
/* datatypes; these codes are only used internally */
/* within cfitsio to make it easier for users      */
/* to deal with unsigned integers.                 */
enum SBYTE_IMG = 10;
enum USHORT_IMG = 20;
enum ULONG_IMG = 40;
enum ULONGLONG_IMG = 80;

enum IMAGE_HDU = 0; /* Primary Array or IMAGE HDU */
enum ASCII_TBL = 1; /* ASCII table HDU  */
enum BINARY_TBL = 2; /* Binary table HDU */
enum ANY_HDU = -1; /* matches any HDU type */

enum READONLY = 0; /* options when opening a file */
enum READWRITE = 1;

/* adopt a hopefully obscure number to use as a null value flag */
enum FLOATNULLVALUE = -9.11912E-36F;
enum DOUBLENULLVALUE = -9.1191291391491E-36;

/* compression algorithm codes */
enum NO_DITHER = -1;
enum SUBTRACTIVE_DITHER_1 = 1;
enum SUBTRACTIVE_DITHER_2 = 2;
enum MAX_COMPRESS_DIM = 6;
enum RICE_1 = 11;
enum GZIP_1 = 21;
enum GZIP_2 = 22;
enum PLIO_1 = 31;
enum HCOMPRESS_1 = 41;
enum BZIP2_1 = 51; /* not publicly supported; only for test purposes */
enum NOCOMPRESS = -1;

enum TRUE = 1;

enum FALSE = 0;

enum CASESEN = 1; /* do case-sensitive string match */
enum CASEINSEN = 0; /* do case-insensitive string match */

enum GT_ID_ALL_URI = 0; /* hierarchical grouping parameters */
enum GT_ID_REF = 1;
enum GT_ID_POS = 2;
enum GT_ID_ALL = 3;
enum GT_ID_REF_URI = 11;
enum GT_ID_POS_URI = 12;

enum OPT_RM_GPT = 0;
enum OPT_RM_ENTRY = 1;
enum OPT_RM_MBR = 2;
enum OPT_RM_ALL = 3;

enum OPT_GCP_GPT = 0;
enum OPT_GCP_MBR = 1;
enum OPT_GCP_ALL = 2;

enum OPT_MCP_ADD = 0;
enum OPT_MCP_NADD = 1;
enum OPT_MCP_REPL = 2;
enum OPT_MCP_MOV = 3;

enum OPT_MRG_COPY = 0;
enum OPT_MRG_MOV = 1;

enum OPT_CMT_MBR = 1;
enum OPT_CMT_MBR_DEL = 11;

struct tcolumn
{
    /* structure used to store table column information */

    char[70] ttype; /* column name = FITS TTYPEn keyword; */
    LONGLONG tbcol; /* offset in row to first byte of each column */
    int tdatatype; /* datatype code of each column */
    LONGLONG trepeat; /* repeat count of column; number of elements */
    double tscale; /* FITS TSCALn linear scaling factor */
    double tzero; /* FITS TZEROn linear scaling zero point */
    LONGLONG tnull; /* FITS null value for int image or binary table cols */
    char[20] strnull; /* FITS null value string for ASCII table columns */
    char[10] tform; /* FITS tform keyword value  */
    c_long twidth; /* width of each ASCII table column */
}

enum VALIDSTRUC = 555; /* magic value used to identify if structure is valid */

struct FITSfile
{
    /* structure used to store basic FITS file information */

    int filehandle; /* handle returned by the file open function */
    int driver; /* defines which set of I/O drivers should be used */
    int open_count; /* number of opened 'fitsfiles' using this structure */
    char* filename; /* file name */
    int validcode; /* magic value used to verify that structure is valid */
    int only_one; /* flag meaning only copy the specified extension */
    int noextsyntax; /* flag for file opened with request to ignore extended syntax*/
    LONGLONG filesize; /* current size of the physical disk file in bytes */
    LONGLONG logfilesize; /* logical size of file, including unflushed buffers */
    int lasthdu; /* is this the last HDU in the file? 0 = no, else yes */
    LONGLONG bytepos; /* current logical I/O pointer position in file */
    LONGLONG io_pos; /* current I/O pointer position in the physical file */
    int curbuf; /* number of I/O buffer currently in use */
    int curhdu; /* current HDU number; 0 = primary array */
    int hdutype; /* 0 = primary array, 1 = ASCII table, 2 = binary table */
    int writemode; /* 0 = readonly, 1 = readwrite */
    int maxhdu; /* highest numbered HDU known to exist in the file */
    int MAXHDU; /* dynamically allocated dimension of headstart array */
    LONGLONG* headstart; /* byte offset in file to start of each HDU */
    LONGLONG headend; /* byte offest in file to end of the current HDU header */
    LONGLONG ENDpos; /* byte offest to where the END keyword was last written */
    LONGLONG nextkey; /* byte offset in file to beginning of next keyword */
    LONGLONG datastart; /* byte offset in file to start of the current data unit */
    int imgdim; /* dimension of image; cached for fast access */
    LONGLONG[99] imgnaxis; /* length of each axis; cached for fast access */
    int tfield; /* number of fields in the table (primary array has 2 */
    int startcol; /* used by ffgcnn to record starting column number */
    LONGLONG origrows; /* original number of rows (value of NAXIS2 keyword)  */
    LONGLONG numrows; /* number of rows in the table (dynamically updated) */
    LONGLONG rowlength; /* length of a table row or image size (bytes) */
    tcolumn* tableptr; /* pointer to the table structure */
    LONGLONG heapstart; /* heap start byte relative to start of data unit */
    LONGLONG heapsize; /* size of the heap, in bytes */

    /* the following elements are related to compressed images */

    /* these record the 'requested' options to be used when the image is compressed */
    int request_compress_type; /* requested image compression algorithm */
    c_long[MAX_COMPRESS_DIM] request_tilesize; /* requested tiling size */
    float request_quantize_level; /* requested quantize level */
    int request_quantize_method; /* requested  quantizing method */
    int request_dither_seed; /* starting offset into the array of random dithering */
    int request_lossy_int_compress; /* lossy compress integer image as if float image? */
    int request_huge_hdu; /* use '1Q' rather then '1P' variable length arrays */
    float request_hcomp_scale; /* requested HCOMPRESS scale factor */
    int request_hcomp_smooth; /* requested HCOMPRESS smooth parameter */

    /* these record the actual options that were used when the image was compressed */
    int compress_type; /* type of compression algorithm */
    c_long[MAX_COMPRESS_DIM] tilesize; /* size of compression tiles */
    float quantize_level; /* floating point quantization level */
    int quantize_method; /* floating point pixel quantization algorithm */
    int dither_seed; /* starting offset into the array of random dithering */

    /* other compression parameters */
    int compressimg; /* 1 if HDU contains a compressed image, else 0 */
    char[12] zcmptype; /* compression type string */
    int zbitpix; /* FITS data type of image (BITPIX) */
    int zndim; /* dimension of image */
    c_long[MAX_COMPRESS_DIM] znaxis; /* length of each axis */
    c_long maxtilelen; /* max number of pixels in each image tile */
    c_long maxelem; /* maximum byte length of tile compressed arrays */

    int cn_compressed; /* column number for COMPRESSED_DATA column */
    int cn_uncompressed; /* column number for UNCOMPRESSED_DATA column */
    int cn_gzip_data; /* column number for GZIP2 lossless compressed data */
    int cn_zscale; /* column number for ZSCALE column */
    int cn_zzero; /* column number for ZZERO column */
    int cn_zblank; /* column number for the ZBLANK column */

    double zscale; /* scaling value, if same for all tiles */
    double zzero; /* zero pt, if same for all tiles */
    double cn_bscale; /* value of the BSCALE keyword in header */
    double cn_bzero; /* value of the BZERO keyword (may be reset) */
    double cn_actual_bzero; /* actual value of the BZERO keyword  */
    int zblank; /* value for null pixels, if not a column */

    int rice_blocksize; /* first compression parameter: Rice pixels/block */
    int rice_bytepix; /* 2nd compression parameter:   Rice bytes/pixel */
    float hcomp_scale; /* 1st hcompress compression parameter */
    int hcomp_smooth; /* 2nd hcompress compression parameter */

    int* tilerow; /* row number of the array of uncompressed tiledata */
    c_long* tiledatasize; /* length of the array of tile data in bytes */
    int* tiletype; /* datatype of the array of tile (TINT, TSHORT, etc) */
    void** tiledata; /* array of uncompressed tile of data, for row *tilerow */
    void** tilenullarray; /* array of optional array of null value flags */
    int* tileanynull; /* anynulls in the array of tile? */

    char* iobuffer; /* pointer to FITS file I/O buffers */
    c_long[NIOBUF] bufrecnum; /* file record number of each of the buffers */
    int[NIOBUF] dirty; /* has the corresponding buffer been modified? */
    int[NIOBUF] ageindex; /* relative age of each buffer */
}

struct fitsfile
{
    /* structure used to store basic HDU information */

    int HDUposition; /* HDU position in file; 0 = first HDU */
    FITSfile* Fptr; /* pointer to FITS file structure */
}

struct iteratorCol
{
    /* structure for the iterator function column information */

    /* elements required as input to fits_iterate_data: */

    fitsfile* fptr; /* pointer to the HDU containing the column */
    int colnum; /* column number in the table (use name if < 1) */
    char[70] colname; /* name (= TTYPEn value) of the column (optional) */
    int datatype; /* output datatype (converted if necessary  */
    int iotype; /* = InputCol, InputOutputCol, or OutputCol */

    /* output elements that may be useful for the work function: */

    void* array; /* pointer to the array (and the null value) */
    c_long repeat; /* binary table vector repeat value */
    c_long tlmin; /* legal minimum data value */
    c_long tlmax; /* legal maximum data value */
    char[70] tunit; /* physical unit string */
    char[70] tdisp; /* suggested display format */
}

enum InputCol = 0; /* flag for input only iterator column       */
enum InputOutputCol = 1; /* flag for input and output iterator column */
enum OutputCol = 2; /* flag for output only iterator column      */
enum TemporaryCol = 3; /* flag for temporary iterator column INTERNAL */

/*=============================================================================
*
*       The following wtbarr typedef is used in the fits_read_wcstab() routine,
*       which is intended for use with the WCSLIB library written by Mark
*       Calabretta, http://www.atnf.csiro.au/~mcalabre/index.html
*
*       In order to maintain WCSLIB and CFITSIO as independent libraries it
*       was not permissible for any CFITSIO library code to include WCSLIB
*       header files, or vice versa.  However, the CFITSIO function
*       fits_read_wcstab() accepts an array of structs defined by wcs.h within
*       WCSLIB.  The problem then was to define this struct within fitsio.h
*       without including wcs.h, especially noting that wcs.h will often (but
*       not always) be included together with fitsio.h in an applications
*       program that uses fits_read_wcstab().
*
*       Of the various possibilities, the solution adopted was for WCSLIB to
*       define "struct wtbarr" while fitsio.h defines "typedef wtbarr", a
*       untagged struct with identical members.  This allows both wcs.h and
*       fitsio.h to define a wtbarr data type without conflict by virtue of
*       the fact that structure tags and typedef names share different
*       namespaces in C. Therefore, declarations within WCSLIB look like
*
*          struct wtbarr *w;
*
*       while within CFITSIO they are simply
*
*          wtbarr *w;
*
*       but as suggested by the commonality of the names, these are really the
*       same aggregate data type.  However, in passing a (struct wtbarr *) to
*       fits_read_wcstab() a cast to (wtbarr *) is formally required.
*===========================================================================*/

struct wtbarr
{
    int i; /* Image axis number.                       */
    int m; /* Array axis number for index vectors.     */
    int kind; /* Array type, 'c' (coord) or 'i' (index).  */
    char[72] extnam; /* EXTNAME of binary table extension.       */
    int extver; /* EXTVER  of binary table extension.       */
    int extlev; /* EXTLEV  of binary table extension.       */
    char[72] ttype; /* TTYPEn of column containing the array.   */
    c_long row; /* Table row number.                        */
    int ndim; /* Expected array dimensionality.           */
    int* dimlen; /* Where to write the array axis lengths.   */
    double** arrayp; /* Where to write the address of the array  */
    /* allocated to store the array.            */
}

/*  The following exclusion if __CINT__ is defined is needed for ROOT */

/*  the following 3 lines are needed to support C++ compilers */

int fits_read_wcstab (fitsfile* fptr, int nwtb, wtbarr* wtb, int* status);

/*  The following exclusion if __CINT__ is defined is needed for ROOT */

/* WCSLIB_GETWCSTAB */

/* error status codes */

enum CREATE_DISK_FILE = -106; /* create disk file, without extended filename syntax */
enum OPEN_DISK_FILE = -105; /* open disk file, without extended filename syntax */
enum SKIP_TABLE = -104; /* move to 1st image when opening file */
enum SKIP_IMAGE = -103; /* move to 1st table when opening file */
enum SKIP_NULL_PRIMARY = -102; /* skip null primary array when opening file */
enum USE_MEM_BUFF = -101; /* use memory buffer when opening file */
enum OVERFLOW_ERR = -11; /* overflow during datatype conversion */
enum PREPEND_PRIMARY = -9; /* used in ffiimg to insert new primary array */
enum SAME_FILE = 101; /* input and output files are the same */
enum TOO_MANY_FILES = 103; /* tried to open too many FITS files */
enum FILE_NOT_OPENED = 104; /* could not open the named file */
enum FILE_NOT_CREATED = 105; /* could not create the named file */
enum WRITE_ERROR = 106; /* error writing to FITS file */
enum END_OF_FILE = 107; /* tried to move past end of file */
enum READ_ERROR = 108; /* error reading from FITS file */
enum FILE_NOT_CLOSED = 110; /* could not close the file */
enum ARRAY_TOO_BIG = 111; /* array dimensions exceed internal limit */
enum READONLY_FILE = 112; /* Cannot write to readonly file */
enum MEMORY_ALLOCATION = 113; /* Could not allocate memory */
enum BAD_FILEPTR = 114; /* invalid fitsfile pointer */
enum NULL_INPUT_PTR = 115; /* NULL input pointer to routine */
enum SEEK_ERROR = 116; /* error seeking position in file */
enum BAD_NETTIMEOUT = 117; /* bad value for file download timeout setting */

enum BAD_URL_PREFIX = 121; /* invalid URL prefix on file name */
enum TOO_MANY_DRIVERS = 122; /* tried to register too many IO drivers */
enum DRIVER_INIT_FAILED = 123; /* driver initialization failed */
enum NO_MATCHING_DRIVER = 124; /* matching driver is not registered */
enum URL_PARSE_ERROR = 125; /* failed to parse input file URL */
enum RANGE_PARSE_ERROR = 126; /* failed to parse input file URL */

enum SHARED_ERRBASE = 150;
enum SHARED_BADARG = SHARED_ERRBASE + 1;
enum SHARED_NULPTR = SHARED_ERRBASE + 2;
enum SHARED_TABFULL = SHARED_ERRBASE + 3;
enum SHARED_NOTINIT = SHARED_ERRBASE + 4;
enum SHARED_IPCERR = SHARED_ERRBASE + 5;
enum SHARED_NOMEM = SHARED_ERRBASE + 6;
enum SHARED_AGAIN = SHARED_ERRBASE + 7;
enum SHARED_NOFILE = SHARED_ERRBASE + 8;
enum SHARED_NORESIZE = SHARED_ERRBASE + 9;

enum HEADER_NOT_EMPTY = 201; /* header already contains keywords */
enum KEY_NO_EXIST = 202; /* keyword not found in header */
enum KEY_OUT_BOUNDS = 203; /* keyword record number is out of bounds */
enum VALUE_UNDEFINED = 204; /* keyword value field is blank */
enum NO_QUOTE = 205; /* string is missing the closing quote */
enum BAD_INDEX_KEY = 206; /* illegal indexed keyword name */
enum BAD_KEYCHAR = 207; /* illegal character in keyword name or card */
enum BAD_ORDER = 208; /* required keywords out of order */
enum NOT_POS_INT = 209; /* keyword value is not a positive integer */
enum NO_END = 210; /* couldn't find END keyword */
enum BAD_BITPIX = 211; /* illegal BITPIX keyword value*/
enum BAD_NAXIS = 212; /* illegal NAXIS keyword value */
enum BAD_NAXES = 213; /* illegal NAXISn keyword value */
enum BAD_PCOUNT = 214; /* illegal PCOUNT keyword value */
enum BAD_GCOUNT = 215; /* illegal GCOUNT keyword value */
enum BAD_TFIELDS = 216; /* illegal TFIELDS keyword value */
enum NEG_WIDTH = 217; /* negative table row size */
enum NEG_ROWS = 218; /* negative number of rows in table */
enum COL_NOT_FOUND = 219; /* column with this name not found in table */
enum BAD_SIMPLE = 220; /* illegal value of SIMPLE keyword  */
enum NO_SIMPLE = 221; /* Primary array doesn't start with SIMPLE */
enum NO_BITPIX = 222; /* Second keyword not BITPIX */
enum NO_NAXIS = 223; /* Third keyword not NAXIS */
enum NO_NAXES = 224; /* Couldn't find all the NAXISn keywords */
enum NO_XTENSION = 225; /* HDU doesn't start with XTENSION keyword */
enum NOT_ATABLE = 226; /* the CHDU is not an ASCII table extension */
enum NOT_BTABLE = 227; /* the CHDU is not a binary table extension */
enum NO_PCOUNT = 228; /* couldn't find PCOUNT keyword */
enum NO_GCOUNT = 229; /* couldn't find GCOUNT keyword */
enum NO_TFIELDS = 230; /* couldn't find TFIELDS keyword */
enum NO_TBCOL = 231; /* couldn't find TBCOLn keyword */
enum NO_TFORM = 232; /* couldn't find TFORMn keyword */
enum NOT_IMAGE = 233; /* the CHDU is not an IMAGE extension */
enum BAD_TBCOL = 234; /* TBCOLn keyword value < 0 or > rowlength */
enum NOT_TABLE = 235; /* the CHDU is not a table */
enum COL_TOO_WIDE = 236; /* column is too wide to fit in table */
enum COL_NOT_UNIQUE = 237; /* more than 1 column name matches template */
enum BAD_ROW_WIDTH = 241; /* sum of column widths not = NAXIS1 */
enum UNKNOWN_EXT = 251; /* unrecognizable FITS extension type */
enum UNKNOWN_REC = 252; /* unrecognizable FITS record */
enum END_JUNK = 253; /* END keyword is not blank */
enum BAD_HEADER_FILL = 254; /* Header fill area not blank */
enum BAD_DATA_FILL = 255; /* Data fill area not blank or zero */
enum BAD_TFORM = 261; /* illegal TFORM format code */
enum BAD_TFORM_DTYPE = 262; /* unrecognizable TFORM datatype code */
enum BAD_TDIM = 263; /* illegal TDIMn keyword value */
enum BAD_HEAP_PTR = 264; /* invalid BINTABLE heap address */

enum BAD_HDU_NUM = 301; /* HDU number < 1 or > MAXHDU */
enum BAD_COL_NUM = 302; /* column number < 1 or > tfields */
enum NEG_FILE_POS = 304; /* tried to move before beginning of file  */
enum NEG_BYTES = 306; /* tried to read or write negative bytes */
enum BAD_ROW_NUM = 307; /* illegal starting row number in table */
enum BAD_ELEM_NUM = 308; /* illegal starting element number in vector */
enum NOT_ASCII_COL = 309; /* this is not an ASCII string column */
enum NOT_LOGICAL_COL = 310; /* this is not a logical datatype column */
enum BAD_ATABLE_FORMAT = 311; /* ASCII table column has wrong format */
enum BAD_BTABLE_FORMAT = 312; /* Binary table column has wrong format */
enum NO_NULL = 314; /* null value has not been defined */
enum NOT_VARI_LEN = 317; /* this is not a variable length column */
enum BAD_DIMEN = 320; /* illegal number of dimensions in array */
enum BAD_PIX_NUM = 321; /* first pixel number greater than last pixel */
enum ZERO_SCALE = 322; /* illegal BSCALE or TSCALn keyword = 0 */
enum NEG_AXIS = 323; /* illegal axis length < 1 */

enum NOT_GROUP_TABLE = 340;
enum HDU_ALREADY_MEMBER = 341;
enum MEMBER_NOT_FOUND = 342;
enum GROUP_NOT_FOUND = 343;
enum BAD_GROUP_ID = 344;
enum TOO_MANY_HDUS_TRACKED = 345;
enum HDU_ALREADY_TRACKED = 346;
enum BAD_OPTION = 347;
enum IDENTICAL_POINTERS = 348;
enum BAD_GROUP_ATTACH = 349;
enum BAD_GROUP_DETACH = 350;

enum BAD_I2C = 401; /* bad int to formatted string conversion */
enum BAD_F2C = 402; /* bad float to formatted string conversion */
enum BAD_INTKEY = 403; /* can't interprete keyword value as integer */
enum BAD_LOGICALKEY = 404; /* can't interprete keyword value as logical */
enum BAD_FLOATKEY = 405; /* can't interprete keyword value as float */
enum BAD_DOUBLEKEY = 406; /* can't interprete keyword value as double */
enum BAD_C2I = 407; /* bad formatted string to int conversion */
enum BAD_C2F = 408; /* bad formatted string to float conversion */
enum BAD_C2D = 409; /* bad formatted string to double conversion */
enum BAD_DATATYPE = 410; /* bad keyword datatype code */
enum BAD_DECIM = 411; /* bad number of decimal places specified */
enum NUM_OVERFLOW = 412; /* overflow during datatype conversion */

enum DATA_COMPRESSION_ERR = 413; /* error in imcompress routines */
enum DATA_DECOMPRESSION_ERR = 414; /* error in imcompress routines */
enum NO_COMPRESSED_TILE = 415; /* compressed tile doesn't exist */

enum BAD_DATE = 420; /* error in date or time conversion */

enum PARSE_SYNTAX_ERR = 431; /* syntax error in parser expression */
enum PARSE_BAD_TYPE = 432; /* expression did not evaluate to desired type */
enum PARSE_LRG_VECTOR = 433; /* vector result too large to return in array */
enum PARSE_NO_OUTPUT = 434; /* data parser failed not sent an out column */
enum PARSE_BAD_COL = 435; /* bad data encounter while parsing column */
enum PARSE_BAD_OUTPUT = 436; /* Output file not of proper type          */

enum ANGLE_TOO_BIG = 501; /* celestial angle too large for projection */
enum BAD_WCS_VAL = 502; /* bad celestial coordinate or pixel value */
enum WCS_ERROR = 503; /* error in celestial coordinate calculation */
enum BAD_WCS_PROJ = 504; /* unsupported type of celestial projection */
enum NO_WCS_KEY = 505; /* celestial coordinate keywords not found */
enum APPROX_WCS_KEY = 506; /* approximate WCS keywords were calculated */

enum NO_CLOSE_ERROR = 999; /* special value used internally to switch off */
/* the error message from ffclos and ffchdu */

/*------- following error codes are used in the grparser.c file -----------*/
enum NGP_ERRBASE = 360; /* base chosen so not to interfere with CFITSIO */
enum NGP_OK = 0;
enum NGP_NO_MEMORY = NGP_ERRBASE + 0; /* malloc failed */
enum NGP_READ_ERR = NGP_ERRBASE + 1; /* read error from file */
enum NGP_NUL_PTR = NGP_ERRBASE + 2; /* null pointer passed as argument */
enum NGP_EMPTY_CURLINE = NGP_ERRBASE + 3; /* line read seems to be empty */
enum NGP_UNREAD_QUEUE_FULL = NGP_ERRBASE + 4; /* cannot unread more then 1 line (or single line twice) */
enum NGP_INC_NESTING = NGP_ERRBASE + 5; /* too deep include file nesting (inf. loop ?) */
enum NGP_ERR_FOPEN = NGP_ERRBASE + 6; /* fopen() failed, cannot open file */
enum NGP_EOF = NGP_ERRBASE + 7; /* end of file encountered */
enum NGP_BAD_ARG = NGP_ERRBASE + 8; /* bad arguments passed */
enum NGP_TOKEN_NOT_EXPECT = NGP_ERRBASE + 9; /* token not expected here */

/*  The following exclusion if __CINT__ is defined is needed for ROOT */

/*  the following 3 lines are needed to support C++ compilers */

int CFITS2Unit (fitsfile* fptr);
fitsfile* CUnit2FITS (int unit);

/*----------------  FITS file URL parsing routines -------------*/
int fits_get_token (char** ptr, char* delimiter, char* token, int* isanumber);
int fits_get_token2 (char** ptr, char* delimiter, char** token, int* isanumber, int* status);
char* fits_split_names (char* list);
int ffiurl (
    char* url,
    char* urltype,
    char* infile,
    char* outfile,
    char* extspec,
    char* rowfilter,
    char* binspec,
    char* colspec,
    int* status);
int ffifile (
    char* url,
    char* urltype,
    char* infile,
    char* outfile,
    char* extspec,
    char* rowfilter,
    char* binspec,
    char* colspec,
    char* pixfilter,
    int* status);
int ffifile2 (
    char* url,
    char* urltype,
    char* infile,
    char* outfile,
    char* extspec,
    char* rowfilter,
    char* binspec,
    char* colspec,
    char* pixfilter,
    char* compspec,
    int* status);
int ffrtnm (char* url, char* rootname, int* status);
int ffexist (const(char)* infile, int* exists, int* status);
int ffexts (
    char* extspec,
    int* extnum,
    char* extname,
    int* extvers,
    int* hdutype,
    char* colname,
    char* rowexpress,
    int* status);
int ffextn (char* url, int* extension_num, int* status);
int ffurlt (fitsfile* fptr, char* urlType, int* status);
int ffbins (
    char* binspec,
    int* imagetype,
    int* haxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    double* weight,
    char* wtname,
    int* recip,
    int* status);
int ffbinr (
    char** binspec,
    char* colname,
    double* minin,
    double* maxin,
    double* binsizein,
    char* minname,
    char* maxname,
    char* binname,
    int* status);
int fits_copy_cell2image (
    fitsfile* fptr,
    fitsfile* newptr,
    char* colname,
    c_long rownum,
    int* status);
int fits_copy_image2cell (
    fitsfile* fptr,
    fitsfile* newptr,
    char* colname,
    c_long rownum,
    int copykeyflag,
    int* status); /* I - first HDU record number to start with */
int fits_copy_pixlist2image (
    fitsfile* infptr,
    fitsfile* outfptr,
    int firstkey,
    int naxis,
    int* colnum,
    int* status);
int ffimport_file (char* filename, char** contents, int* status);
int ffrwrg (
    char* rowlist,
    LONGLONG maxrows,
    int maxranges,
    int* numranges,
    c_long* minrow,
    c_long* maxrow,
    int* status);
int ffrwrgll (
    char* rowlist,
    LONGLONG maxrows,
    int maxranges,
    int* numranges,
    LONGLONG* minrow,
    LONGLONG* maxrow,
    int* status);
/*----------------  FITS file I/O routines -------------*/
int fits_init_cfitsio ();
int ffomem (
    fitsfile** fptr,
    const(char)* name,
    int mode,
    void** buffptr,
    size_t* buffsize,
    size_t deltasize,
    void* function (void* p, size_t newsize) mem_realloc,
    int* status);
int ffopen (fitsfile** fptr, const(char)* filename, int iomode, int* status);
int ffopentest (int soname, fitsfile** fptr, const(char)* filename, int iomode, int* status);

int ffdopn (fitsfile** fptr, const(char)* filename, int iomode, int* status);
int ffeopn (
    fitsfile** fptr,
    const(char)* filename,
    int iomode,
    char* extlist,
    int* hdutype,
    int* status);
int fftopn (fitsfile** fptr, const(char)* filename, int iomode, int* status);
int ffiopn (fitsfile** fptr, const(char)* filename, int iomode, int* status);
int ffdkopn (fitsfile** fptr, const(char)* filename, int iomode, int* status);
int ffreopen (fitsfile* openfptr, fitsfile** newfptr, int* status);
int ffinit (fitsfile** fptr, const(char)* filename, int* status);
int ffdkinit (fitsfile** fptr, const(char)* filename, int* status);
int ffimem (
    fitsfile** fptr,
    void** buffptr,
    size_t* buffsize,
    size_t deltasize,
    void* function (void* p, size_t newsize) mem_realloc,
    int* status);
int fftplt (
    fitsfile** fptr,
    const(char)* filename,
    const(char)* tempname,
    int* status);
int ffflus (fitsfile* fptr, int* status);
int ffflsh (fitsfile* fptr, int clearbuf, int* status);
int ffclos (fitsfile* fptr, int* status);
int ffdelt (fitsfile* fptr, int* status);
int ffflnm (fitsfile* fptr, char* filename, int* status);
int ffflmd (fitsfile* fptr, int* filemode, int* status);
int fits_delete_iraf_file (const(char)* filename, int* status);

/*---------------- utility routines -------------*/

float ffvers (float* version_);
void ffupch (char* string);
void ffgerr (int status, char* errtext);
void ffpmsg (const(char)* err_message);
void ffpmrk ();
int ffgmsg (char* err_message);
void ffcmsg ();
void ffcmrk ();
void ffrprt (FILE* stream, int status);
void ffcmps (char* templt, char* colname, int casesen, int* match, int* exact);
int fftkey (const(char)* keyword, int* status);
int fftrec (char* card, int* status);
int ffnchk (fitsfile* fptr, int* status);
int ffkeyn (const(char)* keyroot, int value, char* keyname, int* status);
int ffnkey (int value, const(char)* keyroot, char* keyname, int* status);
int ffgkcl (char* card);
int ffdtyp (const(char)* cval, char* dtype, int* status);
int ffinttyp (char* cval, int* datatype, int* negative, int* status);
int ffpsvc (char* card, char* value, char* comm, int* status);
int ffgknm (char* card, char* name, int* length, int* status);
int ffgthd (char* tmplt, char* card, int* hdtype, int* status);
int ffmkky (const(char)* keyname, char* keyval, const(char)* comm, char* card, int* status);
int fits_translate_keyword (
    char* inrec,
    char* outrec,
    ref char*[2]* patterns,
    int npat,
    int n_value,
    int n_offset,
    int n_range,
    int* pat_num,
    int* i,
    int* j,
    int* m,
    int* n,
    int* status);
int fits_translate_keywords (
    fitsfile* infptr,
    fitsfile* outfptr,
    int firstkey,
    ref char*[2]* patterns,
    int npat,
    int n_value,
    int n_offset,
    int n_range,
    int* status);
int ffasfm (char* tform, int* datacode, c_long* width, int* decim, int* status);
int ffbnfm (char* tform, int* datacode, c_long* repeat, c_long* width, int* status);
int ffbnfmll (char* tform, int* datacode, LONGLONG* repeat, c_long* width, int* status);
int ffgabc (
    int tfields,
    char** tform,
    int space,
    c_long* rowlen,
    c_long* tbcol,
    int* status);
int fits_get_section_range (
    char** ptr,
    c_long* secmin,
    c_long* secmax,
    c_long* incre,
    int* status);
/* ffmbyt should not normally be used in application programs, but it is
   defined here as a publicly available routine because there are a few
   rare cases where it is needed
*/
int ffmbyt (fitsfile* fptr, LONGLONG bytpos, int ignore_err, int* status);
/*----------------- write single keywords --------------*/
int ffpky (
    fitsfile* fptr,
    int datatype,
    const(char)* keyname,
    void* value,
    const(char)* comm,
    int* status);
int ffprec (fitsfile* fptr, const(char)* card, int* status);
int ffpcom (fitsfile* fptr, const(char)* comm, int* status);
int ffpunt (fitsfile* fptr, const(char)* keyname, const(char)* unit, int* status);
int ffphis (fitsfile* fptr, const(char)* history, int* status);
int ffpdat (fitsfile* fptr, int* status);
int ffverifydate (int year, int month, int day, int* status);
int ffgstm (char* timestr, int* timeref, int* status);
int ffgsdt (int* day, int* month, int* year, int* status);
int ffdt2s (int year, int month, int day, char* datestr, int* status);
int fftm2s (
    int year,
    int month,
    int day,
    int hour,
    int minute,
    double second,
    int decimals,
    char* datestr,
    int* status);
int ffs2dt (char* datestr, int* year, int* month, int* day, int* status);
int ffs2tm (
    char* datestr,
    int* year,
    int* month,
    int* day,
    int* hour,
    int* minute,
    double* second,
    int* status);
int ffpkyu (fitsfile* fptr, const(char)* keyname, const(char)* comm, int* status);
int ffpkys (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffpkls (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffplsw (fitsfile* fptr, int* status);
int ffpkyl (fitsfile* fptr, const(char)* keyname, int value, const(char)* comm, int* status);
int ffpkyj (fitsfile* fptr, const(char)* keyname, LONGLONG value, const(char)* comm, int* status);
int ffpkyuj (fitsfile* fptr, const(char)* keyname, ULONGLONG value, const(char)* comm, int* status);
int ffpkyf (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkye (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkyg (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkyd (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkyc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkym (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkfc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkfm (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);
int ffpkyt (
    fitsfile* fptr,
    const(char)* keyname,
    c_long intval,
    double frac,
    const(char)* comm,
    int* status);
int ffptdm (fitsfile* fptr, int colnum, int naxis, c_long* naxes, int* status);
int ffptdmll (fitsfile* fptr, int colnum, int naxis, LONGLONG* naxes, int* status);

/*----------------- write array of keywords --------------*/
int ffpkns (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    char** value,
    char** comm,
    int* status);
int ffpknl (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    int* value,
    char** comm,
    int* status);
int ffpknj (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    c_long* value,
    char** comm,
    int* status);
int ffpknjj (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    LONGLONG* value,
    char** comm,
    int* status);
int ffpknf (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    float* value,
    int decim,
    char** comm,
    int* status);
int ffpkne (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    float* value,
    int decim,
    char** comm,
    int* status);
int ffpkng (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    double* value,
    int decim,
    char** comm,
    int* status);
int ffpknd (
    fitsfile* fptr,
    const(char)* keyroot,
    int nstart,
    int nkey,
    double* value,
    int decim,
    char** comm,
    int* status);
int ffcpky (
    fitsfile* infptr,
    fitsfile* outfptr,
    int incol,
    int outcol,
    char* rootname,
    int* status);

/*----------------- write required header keywords --------------*/
int ffphps (fitsfile* fptr, int bitpix, int naxis, c_long* naxes, int* status);
int ffphpsll (fitsfile* fptr, int bitpix, int naxis, LONGLONG* naxes, int* status);
int ffphpr (
    fitsfile* fptr,
    int simple,
    int bitpix,
    int naxis,
    c_long* naxes,
    LONGLONG pcount,
    LONGLONG gcount,
    int extend,
    int* status);
int ffphprll (
    fitsfile* fptr,
    int simple,
    int bitpix,
    int naxis,
    LONGLONG* naxes,
    LONGLONG pcount,
    LONGLONG gcount,
    int extend,
    int* status);
int ffphtb (
    fitsfile* fptr,
    LONGLONG naxis1,
    LONGLONG naxis2,
    int tfields,
    char** ttype,
    c_long* tbcol,
    char** tform,
    char** tunit,
    const(char)* extname,
    int* status);
int ffphbn (
    fitsfile* fptr,
    LONGLONG naxis2,
    int tfields,
    char** ttype,
    char** tform,
    char** tunit,
    const(char)* extname,
    LONGLONG pcount,
    int* status);
int ffphext (
    fitsfile* fptr,
    const(char)* xtension,
    int bitpix,
    int naxis,
    c_long* naxes,
    LONGLONG pcount,
    LONGLONG gcount,
    int* status);
/*----------------- write template keywords --------------*/
int ffpktp (fitsfile* fptr, const(char)* filename, int* status);

/*------------------ get header information --------------*/
int ffghsp (fitsfile* fptr, int* nexist, int* nmore, int* status);
int ffghps (fitsfile* fptr, int* nexist, int* position, int* status);

/*------------------ move position in header -------------*/
int ffmaky (fitsfile* fptr, int nrec, int* status);
int ffmrky (fitsfile* fptr, int nrec, int* status);

/*------------------ read single keywords -----------------*/
int ffgnxk (
    fitsfile* fptr,
    char** inclist,
    int ninc,
    char** exclist,
    int nexc,
    char* card,
    int* status);
int ffgrec (fitsfile* fptr, int nrec, char* card, int* status);
int ffgcrd (fitsfile* fptr, const(char)* keyname, char* card, int* status);
int ffgstr (fitsfile* fptr, const(char)* string, char* card, int* status);
int ffgunt (fitsfile* fptr, const(char)* keyname, char* unit, int* status);
int ffgkyn (
    fitsfile* fptr,
    int nkey,
    char* keyname,
    char* keyval,
    char* comm,
    int* status);
int ffgkey (
    fitsfile* fptr,
    const(char)* keyname,
    char* keyval,
    char* comm,
    int* status);

int ffgky (
    fitsfile* fptr,
    int datatype,
    const(char)* keyname,
    void* value,
    char* comm,
    int* status);
int ffgkys (fitsfile* fptr, const(char)* keyname, char* value, char* comm, int* status);
int ffgksl (fitsfile* fptr, const(char)* keyname, int* length, int* status);
int ffgkcsl (fitsfile* fptr, const(char)* keyname, int* length, int* comlength, int* status);
int ffgkls (fitsfile* fptr, const(char)* keyname, char** value, char* comm, int* status);
int ffgsky (
    fitsfile* fptr,
    const(char)* keyname,
    int firstchar,
    int maxchar,
    char* value,
    int* valuelen,
    char* comm,
    int* status);
int ffgskyc (
    fitsfile* fptr,
    const(char)* keyname,
    int firstchar,
    int maxchar,
    int maxcomchar,
    char* value,
    int* valuelen,
    char* comm,
    int* comlen,
    int* status);
int fffree (void* value, int* status);
int fffkls (char* value, int* status);
int ffgkyl (fitsfile* fptr, const(char)* keyname, int* value, char* comm, int* status);
int ffgkyj (fitsfile* fptr, const(char)* keyname, c_long* value, char* comm, int* status);
int ffgkyjj (fitsfile* fptr, const(char)* keyname, LONGLONG* value, char* comm, int* status);
int ffgkyujj (fitsfile* fptr, const(char)* keyname, ULONGLONG* value, char* comm, int* status);
int ffgkye (fitsfile* fptr, const(char)* keyname, float* value, char* comm, int* status);
int ffgkyd (fitsfile* fptr, const(char)* keyname, double* value, char* comm, int* status);
int ffgkyc (fitsfile* fptr, const(char)* keyname, float* value, char* comm, int* status);
int ffgkym (fitsfile* fptr, const(char)* keyname, double* value, char* comm, int* status);
int ffgkyt (
    fitsfile* fptr,
    const(char)* keyname,
    c_long* ivalue,
    double* dvalue,
    char* comm,
    int* status);
int ffgtdm (
    fitsfile* fptr,
    int colnum,
    int maxdim,
    int* naxis,
    c_long* naxes,
    int* status);
int ffgtdmll (
    fitsfile* fptr,
    int colnum,
    int maxdim,
    int* naxis,
    LONGLONG* naxes,
    int* status);
int ffdtdm (
    fitsfile* fptr,
    char* tdimstr,
    int colnum,
    int maxdim,
    int* naxis,
    c_long* naxes,
    int* status);
int ffdtdmll (
    fitsfile* fptr,
    char* tdimstr,
    int colnum,
    int maxdim,
    int* naxis,
    LONGLONG* naxes,
    int* status);

/*------------------ read array of keywords -----------------*/
int ffgkns (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    char** value,
    int* nfound,
    int* status);
int ffgknl (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    int* value,
    int* nfound,
    int* status);
int ffgknj (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    c_long* value,
    int* nfound,
    int* status);
int ffgknjj (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    LONGLONG* value,
    int* nfound,
    int* status);
int ffgkne (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    float* value,
    int* nfound,
    int* status);
int ffgknd (
    fitsfile* fptr,
    const(char)* keyname,
    int nstart,
    int nmax,
    double* value,
    int* nfound,
    int* status);
int ffh2st (fitsfile* fptr, char** header, int* status);
int ffhdr2str (
    fitsfile* fptr,
    int exclude_comm,
    char** exclist,
    int nexc,
    char** header,
    int* nkeys,
    int* status);
int ffcnvthdr2str (
    fitsfile* fptr,
    int exclude_comm,
    char** exclist,
    int nexc,
    char** header,
    int* nkeys,
    int* status);

/*----------------- read required header keywords --------------*/
int ffghpr (
    fitsfile* fptr,
    int maxdim,
    int* simple,
    int* bitpix,
    int* naxis,
    c_long* naxes,
    c_long* pcount,
    c_long* gcount,
    int* extend,
    int* status);

int ffghprll (
    fitsfile* fptr,
    int maxdim,
    int* simple,
    int* bitpix,
    int* naxis,
    LONGLONG* naxes,
    c_long* pcount,
    c_long* gcount,
    int* extend,
    int* status);

int ffghtb (
    fitsfile* fptr,
    int maxfield,
    c_long* naxis1,
    c_long* naxis2,
    int* tfields,
    char** ttype,
    c_long* tbcol,
    char** tform,
    char** tunit,
    char* extname,
    int* status);

int ffghtbll (
    fitsfile* fptr,
    int maxfield,
    LONGLONG* naxis1,
    LONGLONG* naxis2,
    int* tfields,
    char** ttype,
    LONGLONG* tbcol,
    char** tform,
    char** tunit,
    char* extname,
    int* status);

int ffghbn (
    fitsfile* fptr,
    int maxfield,
    c_long* naxis2,
    int* tfields,
    char** ttype,
    char** tform,
    char** tunit,
    char* extname,
    c_long* pcount,
    int* status);

int ffghbnll (
    fitsfile* fptr,
    int maxfield,
    LONGLONG* naxis2,
    int* tfields,
    char** ttype,
    char** tform,
    char** tunit,
    char* extname,
    LONGLONG* pcount,
    int* status);

/*--------------------- update keywords ---------------*/
int ffuky (
    fitsfile* fptr,
    int datatype,
    const(char)* keyname,
    void* value,
    const(char)* comm,
    int* status);
int ffucrd (fitsfile* fptr, const(char)* keyname, const(char)* card, int* status);
int ffukyu (fitsfile* fptr, const(char)* keyname, const(char)* comm, int* status);
int ffukys (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffukls (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffukyl (fitsfile* fptr, const(char)* keyname, int value, const(char)* comm, int* status);
int ffukyj (fitsfile* fptr, const(char)* keyname, LONGLONG value, const(char)* comm, int* status);
int ffukyuj (fitsfile* fptr, const(char)* keyname, ULONGLONG value, const(char)* comm, int* status);
int ffukyf (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffukye (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffukyg (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffukyd (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffukyc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffukym (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);
int ffukfc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffukfm (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);

/*--------------------- modify keywords ---------------*/
int ffmrec (fitsfile* fptr, int nkey, const(char)* card, int* status);
int ffmcrd (fitsfile* fptr, const(char)* keyname, const(char)* card, int* status);
int ffmnam (fitsfile* fptr, const(char)* oldname, const(char)* newname, int* status);
int ffmcom (fitsfile* fptr, const(char)* keyname, const(char)* comm, int* status);
int ffmkyu (fitsfile* fptr, const(char)* keyname, const(char)* comm, int* status);
int ffmkys (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffmkls (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffmkyl (fitsfile* fptr, const(char)* keyname, int value, const(char)* comm, int* status);
int ffmkyj (fitsfile* fptr, const(char)* keyname, LONGLONG value, const(char)* comm, int* status);
int ffmkyuj (fitsfile* fptr, const(char)* keyname, ULONGLONG value, const(char)* comm, int* status);
int ffmkyf (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkye (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkyg (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkyd (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkyc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkym (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkfc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffmkfm (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);

/*--------------------- insert keywords ---------------*/
int ffirec (fitsfile* fptr, int nkey, const(char)* card, int* status);
int ffikey (fitsfile* fptr, const(char)* card, int* status);
int ffikyu (fitsfile* fptr, const(char)* keyname, const(char)* comm, int* status);
int ffikys (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffikls (fitsfile* fptr, const(char)* keyname, const(char)* value, const(char)* comm, int* status);
int ffikyl (fitsfile* fptr, const(char)* keyname, int value, const(char)* comm, int* status);
int ffikyj (fitsfile* fptr, const(char)* keyname, LONGLONG value, const(char)* comm, int* status);
int ffikyf (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffikye (
    fitsfile* fptr,
    const(char)* keyname,
    float value,
    int decim,
    const(char)* comm,
    int* status);
int ffikyg (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffikyd (
    fitsfile* fptr,
    const(char)* keyname,
    double value,
    int decim,
    const(char)* comm,
    int* status);
int ffikyc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffikym (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);
int ffikfc (
    fitsfile* fptr,
    const(char)* keyname,
    float* value,
    int decim,
    const(char)* comm,
    int* status);
int ffikfm (
    fitsfile* fptr,
    const(char)* keyname,
    double* value,
    int decim,
    const(char)* comm,
    int* status);

/*--------------------- delete keywords ---------------*/
int ffdkey (fitsfile* fptr, const(char)* keyname, int* status);
int ffdstr (fitsfile* fptr, const(char)* string, int* status);
int ffdrec (fitsfile* fptr, int keypos, int* status);

/*--------------------- get HDU information -------------*/
int ffghdn (fitsfile* fptr, int* chdunum);
int ffghdt (fitsfile* fptr, int* exttype, int* status);
int ffghad (
    fitsfile* fptr,
    c_long* headstart,
    c_long* datastart,
    c_long* dataend,
    int* status);
int ffghadll (
    fitsfile* fptr,
    LONGLONG* headstart,
    LONGLONG* datastart,
    LONGLONG* dataend,
    int* status);
int ffghof (
    fitsfile* fptr,
    long* headstart,
    long* datastart,
    long* dataend,
    int* status);
int ffgipr (
    fitsfile* fptr,
    int maxaxis,
    int* imgtype,
    int* naxis,
    c_long* naxes,
    int* status);
int ffgiprll (
    fitsfile* fptr,
    int maxaxis,
    int* imgtype,
    int* naxis,
    LONGLONG* naxes,
    int* status);
int ffgidt (fitsfile* fptr, int* imgtype, int* status);
int ffgiet (fitsfile* fptr, int* imgtype, int* status);
int ffgidm (fitsfile* fptr, int* naxis, int* status);
int ffgisz (fitsfile* fptr, int nlen, c_long* naxes, int* status);
int ffgiszll (fitsfile* fptr, int nlen, LONGLONG* naxes, int* status);

/*--------------------- HDU operations -------------*/
int ffmahd (fitsfile* fptr, int hdunum, int* exttype, int* status);
int ffmrhd (fitsfile* fptr, int hdumov, int* exttype, int* status);
int ffmnhd (
    fitsfile* fptr,
    int exttype,
    char* hduname,
    int hduvers,
    int* status);
int ffthdu (fitsfile* fptr, int* nhdu, int* status);
int ffcrhd (fitsfile* fptr, int* status);
int ffcrim (fitsfile* fptr, int bitpix, int naxis, c_long* naxes, int* status);
int ffcrimll (fitsfile* fptr, int bitpix, int naxis, LONGLONG* naxes, int* status);
int ffcrtb (
    fitsfile* fptr,
    int tbltype,
    LONGLONG naxis2,
    int tfields,
    char** ttype,
    char** tform,
    char** tunit,
    const(char)* extname,
    int* status);
int ffiimg (fitsfile* fptr, int bitpix, int naxis, c_long* naxes, int* status);
int ffiimgll (fitsfile* fptr, int bitpix, int naxis, LONGLONG* naxes, int* status);
int ffitab (
    fitsfile* fptr,
    LONGLONG naxis1,
    LONGLONG naxis2,
    int tfields,
    char** ttype,
    c_long* tbcol,
    char** tform,
    char** tunit,
    const(char)* extname,
    int* status);
int ffibin (
    fitsfile* fptr,
    LONGLONG naxis2,
    int tfields,
    char** ttype,
    char** tform,
    char** tunit,
    const(char)* extname,
    LONGLONG pcount,
    int* status);
int ffrsim (fitsfile* fptr, int bitpix, int naxis, c_long* naxes, int* status);
int ffrsimll (fitsfile* fptr, int bitpix, int naxis, LONGLONG* naxes, int* status);
int ffdhdu (fitsfile* fptr, int* hdutype, int* status);
int ffcopy (fitsfile* infptr, fitsfile* outfptr, int morekeys, int* status);
int ffcpfl (
    fitsfile* infptr,
    fitsfile* outfptr,
    int prev,
    int cur,
    int follow,
    int* status);
int ffcphd (fitsfile* infptr, fitsfile* outfptr, int* status);
int ffcpdt (fitsfile* infptr, fitsfile* outfptr, int* status);
int ffchfl (fitsfile* fptr, int* status);
int ffcdfl (fitsfile* fptr, int* status);
int ffwrhdu (fitsfile* fptr, FILE* outstream, int* status);

int ffrdef (fitsfile* fptr, int* status);
int ffrhdu (fitsfile* fptr, int* hdutype, int* status);
int ffhdef (fitsfile* fptr, int morekeys, int* status);
int ffpthp (fitsfile* fptr, c_long theap, int* status);

int ffcsum (fitsfile* fptr, c_long nrec, c_ulong* sum, int* status);
void ffesum (c_ulong sum, int complm, char* ascii);
c_ulong ffdsum (char* ascii, int complm, c_ulong* sum);
int ffpcks (fitsfile* fptr, int* status);
int ffupck (fitsfile* fptr, int* status);
int ffvcks (fitsfile* fptr, int* datastatus, int* hdustatus, int* status);
int ffgcks (fitsfile* fptr, c_ulong* datasum, c_ulong* hdusum, int* status);

/*--------------------- define scaling or null values -------------*/
int ffpscl (fitsfile* fptr, double scale, double zeroval, int* status);
int ffpnul (fitsfile* fptr, LONGLONG nulvalue, int* status);
int fftscl (fitsfile* fptr, int colnum, double scale, double zeroval, int* status);
int fftnul (fitsfile* fptr, int colnum, LONGLONG nulvalue, int* status);
int ffsnul (fitsfile* fptr, int colnum, char* nulstring, int* status);

/*--------------------- get column information -------------*/
int ffgcno (
    fitsfile* fptr,
    int casesen,
    char* templt,
    int* colnum,
    int* status);
int ffgcnn (
    fitsfile* fptr,
    int casesen,
    char* templt,
    char* colname,
    int* colnum,
    int* status);

int ffgtcl (
    fitsfile* fptr,
    int colnum,
    int* typecode,
    c_long* repeat,
    c_long* width,
    int* status);
int ffgtclll (
    fitsfile* fptr,
    int colnum,
    int* typecode,
    LONGLONG* repeat,
    LONGLONG* width,
    int* status);
int ffeqty (
    fitsfile* fptr,
    int colnum,
    int* typecode,
    c_long* repeat,
    c_long* width,
    int* status);
int ffeqtyll (
    fitsfile* fptr,
    int colnum,
    int* typecode,
    LONGLONG* repeat,
    LONGLONG* width,
    int* status);
int ffgncl (fitsfile* fptr, int* ncols, int* status);
int ffgnrw (fitsfile* fptr, c_long* nrows, int* status);
int ffgnrwll (fitsfile* fptr, LONGLONG* nrows, int* status);
int ffgacl (
    fitsfile* fptr,
    int colnum,
    char* ttype,
    c_long* tbcol,
    char* tunit,
    char* tform,
    double* tscal,
    double* tzero,
    char* tnull,
    char* tdisp,
    int* status);
int ffgbcl (
    fitsfile* fptr,
    int colnum,
    char* ttype,
    char* tunit,
    char* dtype,
    c_long* repeat,
    double* tscal,
    double* tzero,
    c_long* tnull,
    char* tdisp,
    int* status);
int ffgbclll (
    fitsfile* fptr,
    int colnum,
    char* ttype,
    char* tunit,
    char* dtype,
    LONGLONG* repeat,
    double* tscal,
    double* tzero,
    LONGLONG* tnull,
    char* tdisp,
    int* status);
int ffgrsz (fitsfile* fptr, c_long* nrows, int* status);
int ffgcdw (fitsfile* fptr, int colnum, int* width, int* status);

/*--------------------- read primary array or image elements -------------*/
int ffgpxv (
    fitsfile* fptr,
    int datatype,
    c_long* firstpix,
    LONGLONG nelem,
    void* nulval,
    void* array,
    int* anynul,
    int* status);
int ffgpxvll (
    fitsfile* fptr,
    int datatype,
    LONGLONG* firstpix,
    LONGLONG nelem,
    void* nulval,
    void* array,
    int* anynul,
    int* status);
int ffgpxf (
    fitsfile* fptr,
    int datatype,
    c_long* firstpix,
    LONGLONG nelem,
    void* array,
    char* nullarray,
    int* anynul,
    int* status);
int ffgpxfll (
    fitsfile* fptr,
    int datatype,
    LONGLONG* firstpix,
    LONGLONG nelem,
    void* array,
    char* nullarray,
    int* anynul,
    int* status);
int ffgsv (
    fitsfile* fptr,
    int datatype,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    void* nulval,
    void* array,
    int* anynul,
    int* status);

int ffgpv (
    fitsfile* fptr,
    int datatype,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* nulval,
    void* array,
    int* anynul,
    int* status);
int ffgpf (
    fitsfile* fptr,
    int datatype,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    char* nullarray,
    int* anynul,
    int* status);
int ffgpvb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte nulval,
    ubyte* array,
    int* anynul,
    int* status);
int ffgpvsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte nulval,
    byte* array,
    int* anynul,
    int* status);
int ffgpvui (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort nulval,
    ushort* array,
    int* anynul,
    int* status);
int ffgpvi (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    short nulval,
    short* array,
    int* anynul,
    int* status);
int ffgpvuj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong nulval,
    c_ulong* array,
    int* anynul,
    int* status);
int ffgpvj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long nulval,
    c_long* array,
    int* anynul,
    int* status);
int ffgpvujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG nulval,
    ULONGLONG* array,
    int* anynul,
    int* status);
int ffgpvjj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG nulval,
    LONGLONG* array,
    int* anynul,
    int* status);
int ffgpvuk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint nulval,
    uint* array,
    int* anynul,
    int* status);
int ffgpvk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    int nulval,
    int* array,
    int* anynul,
    int* status);
int ffgpve (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    float nulval,
    float* array,
    int* anynul,
    int* status);
int ffgpvd (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    double nulval,
    double* array,
    int* anynul,
    int* status);

int ffgpfb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfui (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfi (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfuj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfjj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfuk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfe (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgpfd (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    char* nularray,
    int* anynul,
    int* status);

int ffg2db (
    fitsfile* fptr,
    c_long group,
    ubyte nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ubyte* array,
    int* anynul,
    int* status);
int ffg2dsb (
    fitsfile* fptr,
    c_long group,
    byte nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    byte* array,
    int* anynul,
    int* status);
int ffg2dui (
    fitsfile* fptr,
    c_long group,
    ushort nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ushort* array,
    int* anynul,
    int* status);
int ffg2di (
    fitsfile* fptr,
    c_long group,
    short nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    short* array,
    int* anynul,
    int* status);
int ffg2duj (
    fitsfile* fptr,
    c_long group,
    c_ulong nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    c_ulong* array,
    int* anynul,
    int* status);
int ffg2dj (
    fitsfile* fptr,
    c_long group,
    c_long nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    c_long* array,
    int* anynul,
    int* status);
int ffg2dujj (
    fitsfile* fptr,
    c_long group,
    ULONGLONG nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ULONGLONG* array,
    int* anynul,
    int* status);
int ffg2djj (
    fitsfile* fptr,
    c_long group,
    LONGLONG nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG* array,
    int* anynul,
    int* status);
int ffg2duk (
    fitsfile* fptr,
    c_long group,
    uint nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    uint* array,
    int* anynul,
    int* status);
int ffg2dk (
    fitsfile* fptr,
    c_long group,
    int nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    int* array,
    int* anynul,
    int* status);
int ffg2de (
    fitsfile* fptr,
    c_long group,
    float nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    float* array,
    int* anynul,
    int* status);
int ffg2dd (
    fitsfile* fptr,
    c_long group,
    double nulval,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    double* array,
    int* anynul,
    int* status);

int ffg3db (
    fitsfile* fptr,
    c_long group,
    ubyte nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ubyte* array,
    int* anynul,
    int* status);
int ffg3dsb (
    fitsfile* fptr,
    c_long group,
    byte nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    byte* array,
    int* anynul,
    int* status);
int ffg3dui (
    fitsfile* fptr,
    c_long group,
    ushort nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ushort* array,
    int* anynul,
    int* status);
int ffg3di (
    fitsfile* fptr,
    c_long group,
    short nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    short* array,
    int* anynul,
    int* status);
int ffg3duj (
    fitsfile* fptr,
    c_long group,
    c_ulong nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    c_ulong* array,
    int* anynul,
    int* status);
int ffg3dj (
    fitsfile* fptr,
    c_long group,
    c_long nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    c_long* array,
    int* anynul,
    int* status);
int ffg3dujj (
    fitsfile* fptr,
    c_long group,
    ULONGLONG nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ULONGLONG* array,
    int* anynul,
    int* status);
int ffg3djj (
    fitsfile* fptr,
    c_long group,
    LONGLONG nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    LONGLONG* array,
    int* anynul,
    int* status);
int ffg3duk (
    fitsfile* fptr,
    c_long group,
    uint nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    uint* array,
    int* anynul,
    int* status);
int ffg3dk (
    fitsfile* fptr,
    c_long group,
    int nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    int* array,
    int* anynul,
    int* status);
int ffg3de (
    fitsfile* fptr,
    c_long group,
    float nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    float* array,
    int* anynul,
    int* status);
int ffg3dd (
    fitsfile* fptr,
    c_long group,
    double nulval,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    double* array,
    int* anynul,
    int* status);

int ffgsvb (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ubyte nulval,
    ubyte* array,
    int* anynul,
    int* status);
int ffgsvsb (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    byte nulval,
    byte* array,
    int* anynul,
    int* status);
int ffgsvui (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ushort nulval,
    ushort* array,
    int* anynul,
    int* status);
int ffgsvi (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    short nulval,
    short* array,
    int* anynul,
    int* status);
int ffgsvuj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    c_ulong nulval,
    c_ulong* array,
    int* anynul,
    int* status);
int ffgsvj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    c_long nulval,
    c_long* array,
    int* anynul,
    int* status);
int ffgsvujj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ULONGLONG nulval,
    ULONGLONG* array,
    int* anynul,
    int* status);
int ffgsvjj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    LONGLONG nulval,
    LONGLONG* array,
    int* anynul,
    int* status);
int ffgsvuk (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    uint nulval,
    uint* array,
    int* anynul,
    int* status);
int ffgsvk (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    int nulval,
    int* array,
    int* anynul,
    int* status);
int ffgsve (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    float nulval,
    float* array,
    int* anynul,
    int* status);
int ffgsvd (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    double nulval,
    double* array,
    int* anynul,
    int* status);

int ffgsfb (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ubyte* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfsb (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    byte* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfui (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ushort* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfi (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    short* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfuj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    c_ulong* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    c_long* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfujj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    ULONGLONG* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfjj (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    LONGLONG* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfuk (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    uint* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfk (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    int* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfe (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    float* array,
    char* flagval,
    int* anynul,
    int* status);
int ffgsfd (
    fitsfile* fptr,
    int colnum,
    int naxis,
    c_long* naxes,
    c_long* blc,
    c_long* trc,
    c_long* inc,
    double* array,
    char* flagval,
    int* anynul,
    int* status);

int ffggpb (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ubyte* array,
    int* status);
int ffggpsb (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    byte* array,
    int* status);
int ffggpui (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ushort* array,
    int* status);
int ffggpi (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    short* array,
    int* status);
int ffggpuj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    c_ulong* array,
    int* status);
int ffggpj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    c_long* array,
    int* status);
int ffggpujj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ULONGLONG* array,
    int* status);
int ffggpjj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    LONGLONG* array,
    int* status);
int ffggpuk (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    uint* array,
    int* status);
int ffggpk (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    int* array,
    int* status);
int ffggpe (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    float* array,
    int* status);
int ffggpd (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    double* array,
    int* status);

/*--------------------- read column elements -------------*/
int ffgcv (
    fitsfile* fptr,
    int datatype,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* nulval,
    void* array,
    int* anynul,
    int* status);
int ffgcvn (
    fitsfile* fptr,
    int ncols,
    int* datatype,
    int* colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    void** nulval,
    void** array,
    int* anynul,
    int* status);
int ffgcf (
    fitsfile* fptr,
    int datatype,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    char* nullarray,
    int* anynul,
    int* status);
int ffgcvs (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char* nulval,
    char** array,
    int* anynul,
    int* status);
int ffgcl (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char* array,
    int* status);
int ffgcvl (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char nulval,
    char* array,
    int* anynul,
    int* status);
int ffgcvb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte nulval,
    ubyte* array,
    int* anynul,
    int* status);
int ffgcvsb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte nulval,
    byte* array,
    int* anynul,
    int* status);
int ffgcvui (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort nulval,
    ushort* array,
    int* anynul,
    int* status);
int ffgcvi (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    short nulval,
    short* array,
    int* anynul,
    int* status);
int ffgcvuj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong nulval,
    c_ulong* array,
    int* anynul,
    int* status);
int ffgcvj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long nulval,
    c_long* array,
    int* anynul,
    int* status);
int ffgcvujj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG nulval,
    ULONGLONG* array,
    int* anynul,
    int* status);
int ffgcvjj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG nulval,
    LONGLONG* array,
    int* anynul,
    int* status);
int ffgcvuk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint nulval,
    uint* array,
    int* anynul,
    int* status);
int ffgcvk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    int nulval,
    int* array,
    int* anynul,
    int* status);
int ffgcve (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float nulval,
    float* array,
    int* anynul,
    int* status);
int ffgcvd (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double nulval,
    double* array,
    int* anynul,
    int* status);
int ffgcvc (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float nulval,
    float* array,
    int* anynul,
    int* status);
int ffgcvm (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double nulval,
    double* array,
    int* anynul,
    int* status);

int ffgcx (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstbit,
    LONGLONG nbits,
    char* larray,
    int* status);
int ffgcxui (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    c_long firstbit,
    int nbits,
    ushort* array,
    int* status);
int ffgcxuk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    c_long firstbit,
    int nbits,
    uint* array,
    int* status);

int ffgcfs (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char** array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfl (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfsb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfui (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfi (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfuj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfujj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfjj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfuk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfe (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfd (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfc (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    char* nularray,
    int* anynul,
    int* status);
int ffgcfm (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    char* nularray,
    int* anynul,
    int* status);

int ffgdes (
    fitsfile* fptr,
    int colnum,
    LONGLONG rownum,
    c_long* length,
    c_long* heapaddr,
    int* status);
int ffgdesll (
    fitsfile* fptr,
    int colnum,
    LONGLONG rownum,
    LONGLONG* length,
    LONGLONG* heapaddr,
    int* status);
int ffgdess (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    c_long* length,
    c_long* heapaddr,
    int* status);
int ffgdessll (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    LONGLONG* length,
    LONGLONG* heapaddr,
    int* status);
int ffpdes (
    fitsfile* fptr,
    int colnum,
    LONGLONG rownum,
    LONGLONG length,
    LONGLONG heapaddr,
    int* status);
int fftheap (
    fitsfile* fptr,
    LONGLONG* heapsize,
    LONGLONG* unused,
    LONGLONG* overlap,
    int* valid,
    int* status);
int ffcmph (fitsfile* fptr, int* status);

int ffgtbb (
    fitsfile* fptr,
    LONGLONG firstrow,
    LONGLONG firstchar,
    LONGLONG nchars,
    ubyte* values,
    int* status);

int ffgextn (fitsfile* fptr, LONGLONG offset, LONGLONG nelem, void* array, int* status);
int ffpextn (fitsfile* fptr, LONGLONG offset, LONGLONG nelem, void* array, int* status);

/*------------ write primary array or image elements -------------*/
int ffppx (
    fitsfile* fptr,
    int datatype,
    c_long* firstpix,
    LONGLONG nelem,
    void* array,
    int* status);
int ffppxll (
    fitsfile* fptr,
    int datatype,
    LONGLONG* firstpix,
    LONGLONG nelem,
    void* array,
    int* status);
int ffppxn (
    fitsfile* fptr,
    int datatype,
    c_long* firstpix,
    LONGLONG nelem,
    void* array,
    void* nulval,
    int* status);
int ffppxnll (
    fitsfile* fptr,
    int datatype,
    LONGLONG* firstpix,
    LONGLONG nelem,
    void* array,
    void* nulval,
    int* status);
int ffppr (
    fitsfile* fptr,
    int datatype,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    int* status);
int ffpprb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    int* status);
int ffpprsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    int* status);
int ffpprui (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    int* status);
int ffppri (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    int* status);
int ffppruj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    int* status);
int ffpprj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    int* status);
int ffppruk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    int* status);
int ffpprk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    int* status);
int ffppre (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    int* status);
int ffpprd (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    int* status);
int ffpprjj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    int* status);
int ffpprujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    int* status);

int ffppru (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* status);
int ffpprn (fitsfile* fptr, LONGLONG firstelem, LONGLONG nelem, int* status);

int ffppn (
    fitsfile* fptr,
    int datatype,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    void* nulval,
    int* status);
int ffppnb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    ubyte nulval,
    int* status);
int ffppnsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    byte nulval,
    int* status);
int ffppnui (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    ushort nulval,
    int* status);
int ffppni (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    short nulval,
    int* status);
int ffppnj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    c_long nulval,
    int* status);
int ffppnuj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    c_ulong nulval,
    int* status);
int ffppnuk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    uint nulval,
    int* status);
int ffppnk (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    int nulval,
    int* status);
int ffppne (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    float nulval,
    int* status);
int ffppnd (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    double nulval,
    int* status);
int ffppnjj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    LONGLONG nulval,
    int* status);
int ffppnujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    ULONGLONG nulval,
    int* status);

int ffp2db (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ubyte* array,
    int* status);
int ffp2dsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    byte* array,
    int* status);
int ffp2dui (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ushort* array,
    int* status);
int ffp2di (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    short* array,
    int* status);
int ffp2duj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    c_ulong* array,
    int* status);
int ffp2dj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    c_long* array,
    int* status);
int ffp2duk (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    uint* array,
    int* status);
int ffp2dk (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    int* array,
    int* status);
int ffp2de (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    float* array,
    int* status);
int ffp2dd (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    double* array,
    int* status);
int ffp2djj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG* array,
    int* status);
int ffp2dujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG naxis1,
    LONGLONG naxis2,
    ULONGLONG* array,
    int* status);

int ffp3db (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ubyte* array,
    int* status);
int ffp3dsb (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    byte* array,
    int* status);
int ffp3dui (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ushort* array,
    int* status);
int ffp3di (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    short* array,
    int* status);
int ffp3duj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    c_ulong* array,
    int* status);
int ffp3dj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    c_long* array,
    int* status);
int ffp3duk (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    uint* array,
    int* status);
int ffp3dk (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    int* array,
    int* status);
int ffp3de (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    float* array,
    int* status);
int ffp3dd (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    double* array,
    int* status);
int ffp3djj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    LONGLONG* array,
    int* status);
int ffp3dujj (
    fitsfile* fptr,
    c_long group,
    LONGLONG ncols,
    LONGLONG nrows,
    LONGLONG naxis1,
    LONGLONG naxis2,
    LONGLONG naxis3,
    ULONGLONG* array,
    int* status);

int ffpss (
    fitsfile* fptr,
    int datatype,
    c_long* fpixel,
    c_long* lpixel,
    void* array,
    int* status);
int ffpssb (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    ubyte* array,
    int* status);
int ffpsssb (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    byte* array,
    int* status);
int ffpssui (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    ushort* array,
    int* status);
int ffpssi (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    short* array,
    int* status);
int ffpssuj (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    c_ulong* array,
    int* status);
int ffpssj (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    c_long* array,
    int* status);
int ffpssuk (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    uint* array,
    int* status);
int ffpssk (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    int* array,
    int* status);
int ffpsse (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    float* array,
    int* status);
int ffpssd (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    double* array,
    int* status);
int ffpssjj (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    LONGLONG* array,
    int* status);
int ffpssujj (
    fitsfile* fptr,
    c_long group,
    c_long naxis,
    c_long* naxes,
    c_long* fpixel,
    c_long* lpixel,
    ULONGLONG* array,
    int* status);

int ffpgpb (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ubyte* array,
    int* status);
int ffpgpsb (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    byte* array,
    int* status);
int ffpgpui (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ushort* array,
    int* status);
int ffpgpi (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    short* array,
    int* status);
int ffpgpuj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    c_ulong* array,
    int* status);
int ffpgpj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    c_long* array,
    int* status);
int ffpgpuk (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    uint* array,
    int* status);
int ffpgpk (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    int* array,
    int* status);
int ffpgpe (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    float* array,
    int* status);
int ffpgpd (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    double* array,
    int* status);
int ffpgpjj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    LONGLONG* array,
    int* status);
int ffpgpujj (
    fitsfile* fptr,
    c_long group,
    c_long firstelem,
    c_long nelem,
    ULONGLONG* array,
    int* status);

/*--------------------- iterator functions -------------*/
int fits_iter_set_by_name (
    iteratorCol* col,
    fitsfile* fptr,
    char* colname,
    int datatype,
    int iotype);
int fits_iter_set_by_num (
    iteratorCol* col,
    fitsfile* fptr,
    int colnum,
    int datatype,
    int iotype);
int fits_iter_set_file (iteratorCol* col, fitsfile* fptr);
int fits_iter_set_colname (iteratorCol* col, char* colname);
int fits_iter_set_colnum (iteratorCol* col, int colnum);
int fits_iter_set_datatype (iteratorCol* col, int datatype);
int fits_iter_set_iotype (iteratorCol* col, int iotype);

fitsfile* fits_iter_get_file (iteratorCol* col);
char* fits_iter_get_colname (iteratorCol* col);
int fits_iter_get_colnum (iteratorCol* col);
int fits_iter_get_datatype (iteratorCol* col);
int fits_iter_get_iotype (iteratorCol* col);
void* fits_iter_get_array (iteratorCol* col);
c_long fits_iter_get_tlmin (iteratorCol* col);
c_long fits_iter_get_tlmax (iteratorCol* col);
c_long fits_iter_get_repeat (iteratorCol* col);
char* fits_iter_get_tunit (iteratorCol* col);
char* fits_iter_get_tdisp (iteratorCol* col);

int ffiter (
    int ncols,
    iteratorCol* data,
    c_long offset,
    c_long nPerLoop,
    int function (c_long totaln, c_long offset, c_long firstn, c_long nvalues, int narrays, iteratorCol* data, void* userPointer) workFn,
    void* userPointer,
    int* status);

/*--------------------- write column elements -------------*/
int ffpcl (
    fitsfile* fptr,
    int datatype,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    int* status);
int ffpcln (
    fitsfile* fptr,
    int ncols,
    int* datatype,
    int* colnum,
    LONGLONG firstrow,
    LONGLONG nrows,
    void** array,
    void** nulval,
    int* status);
int ffpcls (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char** array,
    int* status);
int ffpcll (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char* array,
    int* status);
int ffpclb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    int* status);
int ffpclsb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    int* status);
int ffpclui (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    int* status);
int ffpcli (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    int* status);
int ffpcluj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    int* status);
int ffpclj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    int* status);
int ffpcluk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    int* status);
int ffpclk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    int* status);
int ffpcle (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    int* status);
int ffpcld (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    int* status);
int ffpclc (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    int* status);
int ffpclm (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    int* status);
int ffpclu (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* status);
int ffprwu (fitsfile* fptr, LONGLONG firstrow, LONGLONG nrows, int* status);
int ffpcljj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    int* status);
int ffpclujj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    int* status);
int ffpclx (
    fitsfile* fptr,
    int colnum,
    LONGLONG frow,
    c_long fbit,
    c_long nbit,
    char* larray,
    int* status);

int ffpcn (
    fitsfile* fptr,
    int datatype,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    void* array,
    void* nulval,
    int* status);
int ffpcns (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char** array,
    char* nulvalue,
    int* status);
int ffpcnl (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    char* array,
    char nulvalue,
    int* status);
int ffpcnb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ubyte* array,
    ubyte nulvalue,
    int* status);
int ffpcnsb (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    byte* array,
    byte nulvalue,
    int* status);
int ffpcnui (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ushort* array,
    ushort nulvalue,
    int* status);
int ffpcni (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    short* array,
    short nulvalue,
    int* status);
int ffpcnuj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_ulong* array,
    c_ulong nulvalue,
    int* status);
int ffpcnj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    c_long* array,
    c_long nulvalue,
    int* status);
int ffpcnuk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    uint* array,
    uint nulvalue,
    int* status);
int ffpcnk (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    int* array,
    int nulvalue,
    int* status);
int ffpcne (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    float* array,
    float nulvalue,
    int* status);
int ffpcnd (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    double* array,
    double nulvalue,
    int* status);
int ffpcnjj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    LONGLONG* array,
    LONGLONG nulvalue,
    int* status);
int ffpcnujj (
    fitsfile* fptr,
    int colnum,
    LONGLONG firstrow,
    LONGLONG firstelem,
    LONGLONG nelem,
    ULONGLONG* array,
    ULONGLONG nulvalue,
    int* status);
int ffptbb (
    fitsfile* fptr,
    LONGLONG firstrow,
    LONGLONG firstchar,
    LONGLONG nchars,
    ubyte* values,
    int* status);

int ffirow (fitsfile* fptr, LONGLONG firstrow, LONGLONG nrows, int* status);
int ffdrow (fitsfile* fptr, LONGLONG firstrow, LONGLONG nrows, int* status);
int ffdrrg (fitsfile* fptr, char* ranges, int* status);
int ffdrws (fitsfile* fptr, c_long* rownum, c_long nrows, int* status);
int ffdrwsll (fitsfile* fptr, LONGLONG* rownum, LONGLONG nrows, int* status);
int fficol (fitsfile* fptr, int numcol, char* ttype, char* tform, int* status);
int fficls (
    fitsfile* fptr,
    int firstcol,
    int ncols,
    char** ttype,
    char** tform,
    int* status);
int ffmvec (fitsfile* fptr, int colnum, LONGLONG newveclen, int* status);
int ffdcol (fitsfile* fptr, int numcol, int* status);
int ffcpcl (
    fitsfile* infptr,
    fitsfile* outfptr,
    int incol,
    int outcol,
    int create_col,
    int* status);
int ffccls (
    fitsfile* infptr,
    fitsfile* outfptr,
    int incol,
    int outcol,
    int ncols,
    int create_col,
    int* status);
int ffcprw (
    fitsfile* infptr,
    fitsfile* outfptr,
    LONGLONG firstrow,
    LONGLONG nrows,
    int* status);
int ffcpsr (
    fitsfile* infptr,
    fitsfile* outfptr,
    LONGLONG firstrow,
    LONGLONG nrows,
    char* row_status,
    int* status);
int ffcpht (
    fitsfile* infptr,
    fitsfile* outfptr,
    LONGLONG firstrow,
    LONGLONG nrows,
    int* status);

/*--------------------- WCS Utilities ------------------*/
int ffgics (
    fitsfile* fptr,
    double* xrval,
    double* yrval,
    double* xrpix,
    double* yrpix,
    double* xinc,
    double* yinc,
    double* rot,
    char* type,
    int* status);
int ffgicsa (
    fitsfile* fptr,
    char version_,
    double* xrval,
    double* yrval,
    double* xrpix,
    double* yrpix,
    double* xinc,
    double* yinc,
    double* rot,
    char* type,
    int* status);
int ffgtcs (
    fitsfile* fptr,
    int xcol,
    int ycol,
    double* xrval,
    double* yrval,
    double* xrpix,
    double* yrpix,
    double* xinc,
    double* yinc,
    double* rot,
    char* type,
    int* status);
int ffwldp (
    double xpix,
    double ypix,
    double xref,
    double yref,
    double xrefpix,
    double yrefpix,
    double xinc,
    double yinc,
    double rot,
    char* type,
    double* xpos,
    double* ypos,
    int* status);
int ffxypx (
    double xpos,
    double ypos,
    double xref,
    double yref,
    double xrefpix,
    double yrefpix,
    double xinc,
    double yinc,
    double rot,
    char* type,
    double* xpix,
    double* ypix,
    int* status);

/*   WCS support routines (provide interface to Doug Mink's WCS library */
int ffgiwcs (fitsfile* fptr, char** header, int* status);
int ffgtwcs (fitsfile* fptr, int xcol, int ycol, char** header, int* status);

/*--------------------- lexical parsing routines ------------------*/
int fftexp (
    fitsfile* fptr,
    char* expr,
    int maxdim,
    int* datatype,
    c_long* nelem,
    int* naxis,
    c_long* naxes,
    int* status);

int fffrow (
    fitsfile* infptr,
    char* expr,
    c_long firstrow,
    c_long nrows,
    c_long* n_good_rows,
    char* row_status,
    int* status);

int ffffrw (fitsfile* fptr, char* expr, c_long* rownum, int* status);

int fffrwc (
    fitsfile* fptr,
    char* expr,
    char* timeCol,
    char* parCol,
    char* valCol,
    c_long ntimes,
    double* times,
    char* time_status,
    int* status);

int ffsrow (fitsfile* infptr, fitsfile* outfptr, char* expr, int* status);

int ffcrow (
    fitsfile* fptr,
    int datatype,
    char* expr,
    c_long firstrow,
    c_long nelements,
    void* nulval,
    void* array,
    int* anynul,
    int* status);

int ffcalc_rng (
    fitsfile* infptr,
    char* expr,
    fitsfile* outfptr,
    char* parName,
    char* parInfo,
    int nRngs,
    c_long* start,
    c_long* end,
    int* status);

int ffcalc (
    fitsfile* infptr,
    char* expr,
    fitsfile* outfptr,
    char* parName,
    char* parInfo,
    int* status);

/* ffhist is not really intended as a user-callable routine */
/* but it may be useful for some specialized applications   */
/* ffhist2 is a newer version which is strongly recommended instead of ffhist */

int ffhist (
    fitsfile** fptr,
    char* outfile,
    int imagetype,
    int naxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    double weightin,
    ref char[FLEN_VALUE] wtcol,
    int recip,
    char* rowselect,
    int* status);
int ffhist2 (
    fitsfile** fptr,
    char* outfile,
    int imagetype,
    int naxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    double weightin,
    ref char[FLEN_VALUE] wtcol,
    int recip,
    char* rowselect,
    int* status);
fitsfile* ffhist3 (
    fitsfile* fptr,
    char* outfile,
    int imagetype,
    int naxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    double weightin,
    ref char[FLEN_VALUE] wtcol,
    int recip,
    char* selectrow,
    int* status);
int fits_select_image_section (
    fitsfile** fptr,
    char* outfile,
    char* imagesection,
    int* status);
int fits_copy_image_section (
    fitsfile* infptr,
    fitsfile* outfile,
    char* imagesection,
    int* status);

int fits_calc_binning (
    fitsfile* fptr,
    int naxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    int* colnum,
    c_long* haxes,
    float* amin,
    float* amax,
    float* binsize,
    int* status);
int fits_calc_binningd (
    fitsfile* fptr,
    int naxis,
    ref char[FLEN_VALUE][4] colname,
    double* minin,
    double* maxin,
    double* binsizein,
    ref char[FLEN_VALUE][4] minname,
    ref char[FLEN_VALUE][4] maxname,
    ref char[FLEN_VALUE][4] binname,
    int* colnum,
    c_long* haxes,
    double* amin,
    double* amax,
    double* binsize,
    int* status);

int fits_write_keys_histo (
    fitsfile* fptr,
    fitsfile* histptr,
    int naxis,
    int* colnum,
    int* status);
int fits_rebin_wcs (
    fitsfile* fptr,
    int naxis,
    float* amin,
    float* binsize,
    int* status);
int fits_rebin_wcsd (
    fitsfile* fptr,
    int naxis,
    double* amin,
    double* binsize,
    int* status);
int fits_make_hist (
    fitsfile* fptr,
    fitsfile* histptr,
    int bitpix,
    int naxis,
    c_long* naxes,
    int* colnum,
    float* amin,
    float* amax,
    float* binsize,
    float weight,
    int wtcolnum,
    int recip,
    char* selectrow,
    int* status);
int fits_make_histd (
    fitsfile* fptr,
    fitsfile* histptr,
    int bitpix,
    int naxis,
    c_long* naxes,
    int* colnum,
    double* amin,
    double* amax,
    double* binsize,
    double weight,
    int wtcolnum,
    int recip,
    char* selectrow,
    int* status);

struct PixelFilter
{
    /* input(s) */
    int count;
    char** path;
    char** tag;
    fitsfile** ifptr;

    char* expression;

    /* output control */
    int bitpix;
    c_long blank;
    fitsfile* ofptr;
    char[FLEN_KEYWORD] keyword;
    char[FLEN_COMMENT] comment;
}

int fits_pixel_filter (PixelFilter* filter, int* status);

/*--------------------- grouping routines ------------------*/

int ffgtcr (fitsfile* fptr, char* grpname, int grouptype, int* status);
int ffgtis (fitsfile* fptr, char* grpname, int grouptype, int* status);
int ffgtch (fitsfile* gfptr, int grouptype, int* status);
int ffgtrm (fitsfile* gfptr, int rmopt, int* status);
int ffgtcp (fitsfile* infptr, fitsfile* outfptr, int cpopt, int* status);
int ffgtmg (fitsfile* infptr, fitsfile* outfptr, int mgopt, int* status);
int ffgtcm (fitsfile* gfptr, int cmopt, int* status);
int ffgtvf (fitsfile* gfptr, c_long* firstfailed, int* status);
int ffgtop (fitsfile* mfptr, int group, fitsfile** gfptr, int* status);
int ffgtam (fitsfile* gfptr, fitsfile* mfptr, int hdupos, int* status);
int ffgtnm (fitsfile* gfptr, c_long* nmembers, int* status);
int ffgmng (fitsfile* mfptr, c_long* nmembers, int* status);
int ffgmop (fitsfile* gfptr, c_long member, fitsfile** mfptr, int* status);
int ffgmcp (
    fitsfile* gfptr,
    fitsfile* mfptr,
    c_long member,
    int cpopt,
    int* status);
int ffgmtf (
    fitsfile* infptr,
    fitsfile* outfptr,
    c_long member,
    int tfopt,
    int* status);
int ffgmrm (fitsfile* fptr, c_long member, int rmopt, int* status);

/*--------------------- group template parser routines ------------------*/

int fits_execute_template (fitsfile* ff, char* ngp_template, int* status);

int fits_img_stats_short (
    short* array,
    c_long nx,
    c_long ny,
    int nullcheck,
    short nullvalue,
    c_long* ngoodpix,
    short* minvalue,
    short* maxvalue,
    double* mean,
    double* sigma,
    double* noise1,
    double* noise2,
    double* noise3,
    double* noise5,
    int* status);
int fits_img_stats_int (
    int* array,
    c_long nx,
    c_long ny,
    int nullcheck,
    int nullvalue,
    c_long* ngoodpix,
    int* minvalue,
    int* maxvalue,
    double* mean,
    double* sigma,
    double* noise1,
    double* noise2,
    double* noise3,
    double* noise5,
    int* status);
int fits_img_stats_float (
    float* array,
    c_long nx,
    c_long ny,
    int nullcheck,
    float nullvalue,
    c_long* ngoodpix,
    float* minvalue,
    float* maxvalue,
    double* mean,
    double* sigma,
    double* noise1,
    double* noise2,
    double* noise3,
    double* noise5,
    int* status);

/*--------------------- image compression routines ------------------*/

int fits_set_compression_type (fitsfile* fptr, int ctype, int* status);
int fits_set_tile_dim (fitsfile* fptr, int ndim, c_long* dims, int* status);
int fits_set_noise_bits (fitsfile* fptr, int noisebits, int* status);
int fits_set_quantize_level (fitsfile* fptr, float qlevel, int* status);
int fits_set_hcomp_scale (fitsfile* fptr, float scale, int* status);
int fits_set_hcomp_smooth (fitsfile* fptr, int smooth, int* status);
int fits_set_quantize_method (fitsfile* fptr, int method, int* status);
int fits_set_quantize_dither (fitsfile* fptr, int dither, int* status);
int fits_set_dither_seed (fitsfile* fptr, int seed, int* status);
int fits_set_dither_offset (fitsfile* fptr, int offset, int* status);
int fits_set_lossy_int (fitsfile* fptr, int lossy_int, int* status);
int fits_set_huge_hdu (fitsfile* fptr, int huge, int* status);
int fits_set_compression_pref (fitsfile* infptr, fitsfile* outfptr, int* status);

int fits_get_compression_type (fitsfile* fptr, int* ctype, int* status);
int fits_get_tile_dim (fitsfile* fptr, int ndim, c_long* dims, int* status);
int fits_get_quantize_level (fitsfile* fptr, float* qlevel, int* status);
int fits_get_noise_bits (fitsfile* fptr, int* noisebits, int* status);
int fits_get_hcomp_scale (fitsfile* fptr, float* scale, int* status);
int fits_get_hcomp_smooth (fitsfile* fptr, int* smooth, int* status);
int fits_get_dither_seed (fitsfile* fptr, int* seed, int* status);

int fits_img_compress (fitsfile* infptr, fitsfile* outfptr, int* status);

int fits_is_compressed_image (fitsfile* fptr, int* status);
int fits_is_reentrant ();
int fits_img_decompress_header (fitsfile* infptr, fitsfile* outfptr, int* status);
int fits_img_decompress (fitsfile* infptr, fitsfile* outfptr, int* status);

/* H-compress routines */
int fits_hcompress (
    int* a,
    int nx,
    int ny,
    int scale,
    char* output,
    c_long* nbytes,
    int* status);
int fits_hcompress64 (
    LONGLONG* a,
    int nx,
    int ny,
    int scale,
    char* output,
    c_long* nbytes,
    int* status);
int fits_hdecompress (
    ubyte* input,
    int smooth,
    int* a,
    int* nx,
    int* ny,
    int* scale,
    int* status);
int fits_hdecompress64 (
    ubyte* input,
    int smooth,
    LONGLONG* a,
    int* nx,
    int* ny,
    int* scale,
    int* status);

int fits_compress_table (fitsfile* infptr, fitsfile* outfptr, int* status);
int fits_uncompress_table (fitsfile* infptr, fitsfile* outfptr, int* status);

/* curl library wrapper routines (for https access) */

void ffshdwn (int flag);
int ffgtmo ();
int ffstmo (int sec, int* status);

/*  The following exclusion if __CINT__ is defined is needed for ROOT */

