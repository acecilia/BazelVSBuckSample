.PHONY : install_buck build test

BUILDTOOL=buck

setup_config:
	rm -rf config && ln -s ${BUILDTOOL}_config config

build: setup_config
	# Build all targets recursively
	$(BUILDTOOL) build //...

test: setup_config
	# Test all targets recursively
	$(BUILDTOOL) test //...