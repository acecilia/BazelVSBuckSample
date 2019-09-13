.PHONY : build test

BAZEL=bazel

build:
	# Build all targets recursively
	$(BAZEL) build //...

test:
	# Test all targets recursively
	$(BAZEL) test //...