load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test")

def swift_library_target(
    name,
    srcs,
    deps,
    ):
    swift_library(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
    )

def swift_test_target(
    name,
    srcs,
    deps,
    ):
    swift_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
    )