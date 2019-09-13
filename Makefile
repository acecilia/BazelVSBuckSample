.PHONY : install_buck build test

BUILDTOOL=buck

setup_config:
	rm -rf config/selected_config && ln -s ${BUILDTOOL}_config config/selected_config

build: setup_config
	# Build all targets recursively
	$(BUILDTOOL) build //...

test: setup_config
	# Test all targets recursively
	$(BUILDTOOL) test //...

clean: setup_config
	$(BUILDTOOL) clean