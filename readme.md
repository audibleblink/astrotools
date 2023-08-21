# astrotools

Makefile utils for processing Astrophotography data.

## Requirements

- Siril-CLI
- Starnet++
- ImageMagick

```sh
❯❯ make

init                           Create a new workspace
clean                          Delete Siril artifacts. Ex: *.tif|*.fit and scratch dirs
purge                          Delete everything except the makefile and readme
import                         Copy ASIAIR data from $DATA to ${dirs}
archive                        Archive fit/psd files as ./YYYY.MM.DD_$OBJ.tar.zst
%.starless.tif                 Create a starless image from $*.tif
%.stars.tif                    Create stars and mask tifs from $*
%.tif                          Convert $*.fit into a 16-bit TIFF
```

- `%.stars.tif` has a pre-req that installs imagemagick
- `%.starless.tif` has a pre-req that installs starnet++
- `import` requires $OBJ, which is the photographed object directory under $DATA/lights
- `%.tif` requires `siril-cli` be in `$PATH`
