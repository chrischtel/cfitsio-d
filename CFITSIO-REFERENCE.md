# CFITSIO Function Reference

> **NOTICE:**  
> This reference maps the “long” CFITSIO function names (e.g., `fits_open_file`) to their actual C function names (e.g., `ffopn`).  
> **The longname module is not yet implemented in these bindings.**  
> Please use this table to find the correct function for your needs.

---

## Copyright and License

This file is based on the CFITSIO header mappings.  
CFITSIO is maintained by NASA/GSFC and is distributed under the following license:

```
Copyright (Unpublished--all rights reserved under the copyright laws of the United States)
NASA/GSFC
```

See [CFITSIO License](https://heasarc.gsfc.nasa.gov/fitsio/c/cfitsio.html) for details.

---

## Function Name Mapping Table

| Long Name (fits_*)                | C Function (short name) | Description (to be filled) |
|------------------------------------|-------------------------|----------------------------|
| fits_parse_input_url               | ffiurl                  |                            |
| fits_parse_input_filename          | ffifile                 |                            |
| fits_parse_rootname                | ffrtnm                  |                            |
| fits_file_exists                   | ffexist                 |                            |
| fits_parse_output_url              | ffourl                  |                            |
| fits_parse_extspec                 | ffexts                  |                            |
| fits_parse_extnum                  | ffextn                  |                            |
| fits_parse_binspec                 | ffbins                  |                            |
| fits_parse_binrange                | ffbinr                  |                            |
| fits_parse_range                   | ffrwrg                  |                            |
| fits_parse_rangell                 | ffrwrgll                |                            |
| fits_open_memfile                  | ffomem                  |                            |
| fits_open_file                     | ffopen                  | Open a FITS file           |
| fits_open_data                     | ffdopn                  |                            |
| fits_open_extlist                  | ffeopn                  |                            |
| fits_open_table                    | fftopn                  |                            |
| fits_open_image                    | ffiopn                  |                            |
| fits_open_diskfile                 | ffdkopn                 |                            |
| fits_reopen_file                   | ffreopen                |                            |
| fits_create_file                   | ffinit                  |                            |
| fits_create_diskfile               | ffdkinit                |                            |
| fits_create_memfile                | ffimem                  |                            |
| fits_create_template               | fftplt                  |                            |
| fits_flush_file                    | ffflus                  |                            |
| fits_flush_buffer                  | ffflsh                  |                            |
| fits_close_file                    | ffclos                  |                            |
| fits_delete_file                   | ffdelt                  |                            |
| fits_file_name                     | ffflnm                  |                            |
| fits_file_mode                     | ffflmd                  |                            |
| fits_url_type                      | ffurlt                  |                            |
| fits_get_version                   | ffvers                  |                            |
| fits_uppercase                     | ffupch                  |                            |
| fits_get_errstatus                 | ffgerr                  |                            |
| fits_write_errmsg                  | ffpmsg                  |                            |
| fits_write_errmark                 | ffpmrk                  |                            |
| fits_read_errmsg                   | ffgmsg                  |                            |
| fits_clear_errmsg                  | ffcmsg                  |                            |
| fits_clear_errmark                 | ffcmrk                  |                            |
| fits_report_error                  | ffrprt                  |                            |
| fits_compare_str                   | ffcmps                  |                            |
| fits_test_keyword                  | fftkey                  |                            |
| fits_test_record                   | fftrec                  |                            |
| fits_null_check                    | ffnchk                  |                            |
| fits_make_keyn                     | ffkeyn                  |                            |
| fits_make_nkey                     | ffnkey                  |                            |
| fits_make_key                      | ffmkky                  |                            |
| fits_get_keyclass                  | ffgkcl                  |                            |
| fits_get_keytype                   | ffdtyp                  |                            |
| fits_get_inttype                   | ffinttyp                |                            |
| fits_parse_value                   | ffpsvc                  |                            |
| fits_get_keyname                   | ffgknm                  |                            |
| fits_parse_template                | ffgthd                  |                            |
| fits_ascii_tform                   | ffasfm                  |                            |
| fits_binary_tform                  | ffbnfm                  |                            |
| fits_binary_tformll                | ffbnfmll                |                            |
| fits_get_tbcol                     | ffgabc                  |                            |
| fits_get_rowsize                   | ffgrsz                  |                            |
| fits_get_col_display_width         | ffgcdw                  |                            |
| fits_write_record                  | ffprec                  |                            |
| fits_write_key                     | ffpky                   |                            |
| fits_write_key_unit                | ffpunt                  |                            |
| fits_write_comment                 | ffpcom                  |                            |
| fits_write_history                 | ffphis                  |                            |
| fits_write_date                    | ffpdat                  |                            |
| fits_get_system_time               | ffgstm                  |                            |
| fits_get_system_date               | ffgsdt                  |                            |
| fits_date2str                      | ffdt2s                  |                            |
| fits_time2str                      | fftm2s                  |                            |
| fits_str2date                      | ffs2dt                  |                            |
| fits_str2time                      | ffs2tm                  |                            |
| fits_write_key_longstr             | ffpkls                  |                            |
| fits_write_key_longwarn            | ffplsw                  |                            |
| fits_write_key_null                | ffpkyu                  |                            |
| fits_write_key_str                 | ffpkys                  |                            |
| fits_write_key_log                 | ffpkyl                  |                            |
| fits_write_key_lng                 | ffpkyj                  |                            |
| fits_write_key_ulng                | ffpkyuj                 |                            |
| fits_write_key_fixflt              | ffpkyf                  |                            |
| fits_write_key_flt                 | ffpkye                  |                            |
| fits_write_key_fixdbl              | ffpkyg                  |                            |
| fits_write_key_dbl                 | ffpkyd                  |                            |
| fits_write_key_fixcmp              | ffpkfc                  |                            |
| fits_write_key_cmp                 | ffpkyc                  |                            |
| fits_write_key_fixdblcmp           | ffpkfm                  |                            |
| fits_write_key_dblcmp              | ffpkym                  |                            |
| fits_write_key_triple              | ffpkyt                  |                            |
| fits_write_tdim                    | ffptdm                  |                            |
| fits_write_tdimll                  | ffptdmll                |                            |
| fits_write_keys_str                | ffpkns                  |                            |
| fits_write_keys_log                | ffpknl                  |                            |
| fits_write_keys_lng                | ffpknj                  |                            |
| fits_write_keys_fixflt             | ffpknf                  |                            |
| fits_write_keys_flt                | ffpkne                  |                            |
| fits_write_keys_fixdbl             | ffpkng                  |                            |
| fits_write_keys_dbl                | ffpknd                  |                            |
| fits_copy_key                      | ffcpky                  |                            |
| fits_write_imghdr                  | ffphps                  |                            |
| fits_write_imghdrll                | ffphpsll                |                            |
| fits_write_grphdr                  | ffphpr                  |                            |
| fits_write_grphdrll                | ffphprll                |                            |
| fits_write_atblhdr                 | ffphtb                  |                            |
| fits_write_btblhdr                 | ffphbn                  |                            |
| fits_write_exthdr                  | ffphext                 |                            |
| fits_write_key_template            | ffpktp                  |                            |
| fits_get_hdrspace                  | ffghsp                  |                            |
| fits_get_hdrpos                    | ffghps                  |                            |
| fits_movabs_key                    | ffmaky                  |                            |
| fits_movrel_key                    | ffmrky                  |                            |
| fits_find_nextkey                  | ffgnxk                  |                            |
| fits_read_record                   | ffgrec                  |                            |
| fits_read_card                     | ffgcrd                  |                            |
| fits_read_str                      | ffgstr                  |                            |
| fits_read_key_unit                 | ffgunt                  |                            |
| fits_read_keyn                     | ffgkyn                  |                            |
| fits_read_key                      | ffgky                   |                            |
| fits_read_keyword                  | ffgkey                  |                            |
| fits_read_key_str                  | ffgkys                  |                            |
| fits_read_key_log                  | ffgkyl                  |                            |
| fits_read_key_lng                  | ffgkyj                  |                            |
| fits_read_key_lnglng               | ffgkyjj                 |                            |
| fits_read_key_ulnglng              | ffgkyujj                |                            |
| fits_read_key_flt                  | ffgkye                  |                            |
| fits_read_key_dbl                  | ffgkyd                  |                            |
| fits_read_key_cmp                  | ffgkyc                  |                            |
| fits_read_key_dblcmp               | ffgkym                  |                            |
| fits_read_key_triple               | ffgkyt                  |                            |
| fits_get_key_strlen                | ffgksl                  |                            |
| fits_get_key_com_strlen            | ffgkcsl                 |                            |
| fits_read_key_longstr              | ffgkls                  |                            |
| fits_read_string_key               | ffgsky                  |                            |
| fits_read_string_key_com           | ffgskyc                 |                            |
| fits_free_memory                   | fffree                  |                            |
| fits_read_tdim                     | ffgtdm                  |                            |
| fits_read_tdimll                   | ffgtdmll                |                            |
| fits_decode_tdim                   | ffdtdm                  |                            |
| fits_decode_tdimll                 | ffdtdmll                |                            |
| fits_read_keys_str                 | ffgkns                  |                            |
| fits_read_keys_log                 | ffgknl                  |                            |
| fits_read_keys_lng                 | ffgknj                  |                            |
| fits_read_keys_lnglng              | ffgknjj                 |                            |
| fits_read_keys_flt                 | ffgkne                  |                            |
| fits_read_keys_dbl                 | ffgknd                  |                            |
| fits_read_imghdr                   | ffghpr                  |                            |
| fits_read_imghdrll                 | ffghprll                |                            |
| fits_read_atblhdr                  | ffghtb                  |                            |
| fits_read_btblhdr                  | ffghbn                  |                            |
| fits_read_atblhdrll                | ffghtbll                |                            |
| fits_read_btblhdrll                | ffghbnll                |                            |
| fits_hdr2str                       | ffhdr2str               |                            |
| fits_convert_hdr2str               | ffcnvthdr2str           |                            |
| ...                                | ...                     | ...                        |

*This table is incomplete for brevity. Please refer to the header for the full list and add descriptions as you implement each function.*

---

## Notes

- **Missing longname module:**  
  The longname mapping module is not yet implemented in these bindings.  
  Use the table above to manually map long names to the correct C function names.

- **Contributions:**  
  If you add a new function or description, please update this file to help other users.

---

