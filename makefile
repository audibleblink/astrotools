# DATA ?= /Volumes/AIRUSB/ASIAIR/Autorun
DATA ?= /Volumes/ASIAIR/Autorun
ai_model = /opt/homebrew/Cellar/starnet2++/bin/starnet2_weights.pb
scratch = process
dirs = biases flats darks lights ${scratch}

help:
	@grep -E '^[a-zA-Z0-9\.%]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

new: $(dirs) ## Create a new workspace

clean: ## Delete Siril artifacts
	rm -rf *.fit ${scratch} 2>/dev/null

superclean: ## Delete everything except the makefile
	@rm -rf $(filter-out makefile, $(wildcard *))

import: obj-check | new ## Copy ASIAIR data from $DATA to ${dirs}
	rsync -a --progress ${DATA}/Dark/*.fit darks
	rsync -a --progress ${DATA}/Bias/*.fit biases
	rsync -a --progress ${DATA}/Flat/*.fit flats
	rsync -a --progress ${DATA}/Light/${OBJ}/*.fit lights

%.starless.tif: starnet2_weights.pb ## Create a starless image from $*.tif
	DYLD_LIBRARY_PATH=$${DYLD_LIBRARY_PATH}:/opt/homebrew/lib starnet2++ $*.tif $@
	rm $<

.ONESHELL:
%.tif: ## Convert $*.fit into a 16-bit TIFF
	siril-cli -s - <<SNET # >/dev/null
	requires 0.99.4
	load $*.fit
	savetif $*
	SNET

%.tar.gz: ## Zip the current workdir as ../YYYY.MM.DD_%.tar.gz
	@tar -cf $(shell date '+%Y.%m.%d')_$@ . 2>/dev/null
	@mv *.tar.gz ../


################################################################################

starnet2_weights.pb:
	ln -s ${ai_model} .

$(dirs):
	@mkdir -p $@

obj-check:
ifndef OBJ
	$(error OBJ is undefined)
endif

.PHONY: help clean new archive superclean obj-check
