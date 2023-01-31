# astrotools

Makefile-driven utils for processing AP data.


```sh
❯❯ make
init                           Create a new workspace
clean                          Delete Siril artifacts
purge                          Delete everything except the makefile
import                         Copy ASIAIR data from $DATA to ${dirs}
%.starless.tif                 Create a starless image from $*.tif
%.stars.tif                    Create stars and mask tifs from $*
%.tif                          Convert $*.fit into a 16-bit TIFF
%.tar.gz                       Zip the current workdir as ../YYYY.MM.DD_%.tar.gz
```

- `%.stars.tif` has a pre-req that installs imagemagick
- `%.starless.tif` has a pre-req that installs starnet++ if not found in `${HOMEBREW_PREFIX}/bin`
- `import` requires $OBJ, which is the photographed object under $DATA/lights
- `%.tif` requires `siril-cli` be in `$PATH`
