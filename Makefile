.PHONY : build test

BAZEL=bazel

build:
	$(BAZEL) build //Libraries/SwiftWithTests:MainTarget

test:
	$(BAZEL) test //Libraries/SwiftWithTests:MainTargetTests