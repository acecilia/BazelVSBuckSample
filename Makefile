.PHONY : build

BAZEL=bazel

build:
	$(BAZEL) build //Libraries/SwiftWithTests:MainTarget --verbose_failures