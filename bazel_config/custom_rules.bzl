load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test")

# Constants
srcs_glob = ["Sources/**/*.swift"]
test_srcs_glob = ["Tests/**/*.swift"]

# Functions
def generate_test_name(name): 
    return name + "Tests"

# Macros
def first_party_library(
    name,
    deps = [],
    test_deps = [],
    ):
    srcs = native.glob(srcs_glob)
    swift_library(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
    )

    test_name = generate_test_name(name)
    test_srcs = native.glob(test_srcs_glob)
    swift_test(
        name = test_name,
        module_name = test_name,
        deps = [":" + name] + test_deps,
        srcs = test_srcs,
    )