.PHONY : build test

BAZEL=bazel

build:
	$(BAZEL) build //Libraries/SwiftWithTests:MainTarget

test:
	# Test all targets recursively
	$(BAZEL) test //...