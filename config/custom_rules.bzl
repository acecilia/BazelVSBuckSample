# This file includes several macros to easily setup your build system
# The logic in this file is builtool agnostic

# The rule_interfaces.bzl is the file that contains the concrete implementation 
# of the rules for the different buildtools
load(
    "//config/selected_config:rule_interfaces.bzl", 
    "build_system",
    "swift_library_interface", 
    "swift_test_interface", 
    "prebuilt_apple_framework_interface",
    )

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
    swift_library_interface(
        name = name,
        srcs = srcs,
        deps = deps,
    )

    # This is needed for buck
    # See: https://github.com/airbnb/BuckSample/blob/24472210a105f7e3a5e71842ed79cae7bbc6e07e/Libraries/SwiftWithPrecompiledDependency/BUCK#L9
    if build_system == "buck":
        test_deps = test_deps + deps

    test_name = generate_test_name(name)
    test_srcs = native.glob(test_srcs_glob)
    swift_test_interface(
        name = test_name,
        deps = [":" + name] + test_deps,
        srcs = test_srcs,
    )

def prebuilt_apple_framework(
    name,
    path,
    ):
    prebuilt_apple_framework_interface(
        name = name,
        path = path,
    )