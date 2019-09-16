.PHONY : install_buck build test

# $${BUILDTOOL:?} is used in order to fail if variable is not set. See: https://stackoverflow.com/a/50642440

# Do not print commands being executed
MAKEFLAGS = --silent

ifndef BUILDTOOL
	export BUILDTOOL=bazel
endif

setup_config:
	rm -rf config/selected_config && ln -s $${BUILDTOOL:?}_config config/selected_config

build: setup_config
	# Build all targets recursively
	$${BUILDTOOL:?} build //...

test: setup_config
	# Test all targets recursively
	$${BUILDTOOL:?} test //... # --test_output=all --cache_test_results=no # For debugging bazel

clean: setup_config
	$${BUILDTOOL:?} clean