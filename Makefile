.PHONY : setup_config build test list clean

# Do not print commands being executed
MAKEFLAGS = --silent

ifndef BUILDTOOL
	export BUILDTOOL=bazel
endif

setup_config:
	rm -rf config/selected_config && ln -s $(BUILDTOOL)_config config/selected_config

build: setup_config
	# Build all targets recursively
	$(BUILDTOOL) build //Libraries/...

test: setup_config
	# Test all targets recursively
	$(BUILDTOOL) test //Libraries/...

list: setup_config
ifeq ($(BUILDTOOL),buck)
	$(BUILDTOOL) targets //Libraries/...
else
	$(BUILDTOOL) query //Libraries/...
endif

clean: setup_config
	$(BUILDTOOL) clean