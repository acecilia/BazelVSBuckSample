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
    "application_interface"
    )

# Constants
srcs_glob = ["Sources/**/*.swift"]
test_srcs_glob = ["Tests/**/*.swift"]
app_test_srcs_glob = ["AppTests/**/*.swift"]

# Functions
def generate_tests_name(name): 
    return name + "Tests"

def generate_app_name(name): 
    return name + "Application"

def generate_app_tests_name(name): 
    return name + "AppTests"

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

    swift_test_interface(
        name = generate_tests_name(name),
        deps = [":" + name] + test_deps,
        srcs = native.glob(test_srcs_glob),
    )

def prebuilt_apple_framework(
    path,
    ):
    basename_without_extension = path.replace('.', '/').split('/')[::-1][1]
    prebuilt_apple_framework_interface(
        name = basename_without_extension,
        path = path,
    )

def application(
    name,
    infoplist,
    deps,
    ):
    first_party_library(
        name = name,
    )

    swift_test_interface(
        name = generate_app_tests_name(name),
        deps = [":" + name],
        srcs = native.glob(app_test_srcs_glob),
        test_host = ":" + generate_app_name(name),
    )

    application_interface(
        name = generate_app_name(name),
        infoplist = infoplist,
        deps = [":" + name] + deps,
    )