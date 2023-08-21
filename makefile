MAKEFLAGS += --no-print-directory

DATA ?= /Volumes/AIRUSB/ASIAIR/Autorun
STARNET ?= ${HOMEBREW_PREFIX}/bin/starnet++
MAGICK ?= ${HOMEBREW_PREFIX}/bin/magick

scratch = process results masters
dirs = biases flats darks lights ${scratch}


help:
	@grep -E '^[a-zA-Z0-9\.%]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: $(dirs) ## Create a new workspace

clean: ## Delete Siril artifacts. Ex: *.tif|*.fit and scratch dirs
	rm -rf *.fit *.tif ${scratch} 2>/dev/null

purge: ## Delete everything except the makefile and readme
	rm -rf $(filter-out makefile readme.md, $(wildcard *))

import: obj-check | init ## Copy ASIAIR data from $DATA to ${dirs}
	rsync -a --progress ${DATA}/Dark/*.fit darks
	rsync -a --progress ${DATA}/Bias/*.fit biases
	rsync -a --progress ${DATA}/Flat/*.fit flats
	rsync -a --progress ${DATA}/Light/${OBJ}/*.fit lights

%.starless.tif: $(STARNET) ## Create a starless image from $*.tif
	$(MAKE) $*.tif
	$< $*.tif $@

%.stars.tif: $(MAGICK) ## Create stars and mask tifs from $*
	$(MAKE) $*.starless.tif
	$< $*.tif $*.starless.tif -compose Difference -composite $*.diff.tif
	$< $*.tif $*.diff.tif -alpha off -compose CopyOpacity -composite $@

.ONESHELL:
%.tif: ## Convert $*.fit into a 16-bit TIFF
	siril-cli -s - <<SNET # >/dev/null
	requires 0.99.4
	load $*.fit
	savetif $*
	SNET

%.tar.gz: clean ## Clean and zip the current workdir as ./YYYY.MM.DD_%.tar.gz. Excludes *.psd files
	@tar -czf $(shell date '+%Y.%m.%d')_$@ --exclude '"*.psd"' . 2>/dev/null


################################################################################

$(STARNET):
	brew install starnet-plus-plus

$(MAGICK):
	brew install imagemagick

$(dirs):
	@mkdir -p $@

obj-check:
ifndef OBJ
	$(error OBJ is undefined)
endif

.PHONY: help clean init purge obj-check import
