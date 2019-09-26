# This file includes several macros to easily setup your build system
# The logic in this file is builtool agnostic

# The rule_interfaces.bzl is the file that contains the concrete implementation 
# of the rules for the different buildtools
load(
    "//config/selected_config:rule_interfaces.bzl", 
    "build_system",
    "swift_library_interface", 
    "swift_test_interface", 
    "prebuilt_dynamic_framework_interface",
    "application_interface"
    )

# Constants
main_code_path = "Sources"
test_code_path = "Tests"
app_test_code_path = "AppTests"

# swift
swift_files_glob = "/**/*.swift"
swift_srcs_glob = [main_code_path + swift_files_glob]
swift_test_srcs_glob = [test_code_path + swift_files_glob]
swift_app_test_srcs_glob = [app_test_code_path + swift_files_glob]

#objective-c
objc_files_glob = "/**/*.m"
objc_header_files_glob = "/**/*.h"
objc_srcs_glob = [main_code_path + objc_files_glob]
objc_test_srcs_glob = [test_code_path + objc_files_glob]
objc_app_test_srcs_glob = [app_test_code_path + objc_files_glob]

# Functions
def generate_glob(name): 
    return native.glob(swift_srcs_glob)

def generate_tests_name(name): 
    return name + "Tests"

def generate_app_tests_name(name): 
    return name + "AppTests"

def generate_app_name(name): 
    return name + "Bundle"


# Macros
def first_party_library(
    name,
    deps = [],
    test_deps = [],
    ):
    swift_srcs = native.glob(swift_srcs_glob)
    if len(swift_srcs) > 0:
        swift_library_interface(
            name = name,
            srcs = swift_srcs,
            deps = deps,
        )

    test_srcs = native.glob(swift_test_srcs_glob)
    if len(test_srcs) > 0:
        swift_test_interface(
            name = generate_tests_name(name),
            deps = [":" + name] + test_deps,
            srcs = test_srcs,
            host_app = None,
        )

def prebuilt_dynamic_framework(
    path,
    ):
    basename_without_extension = path.replace('.', '/').split('/')[::-1][1]
    prebuilt_dynamic_framework_interface(
        name = basename_without_extension,
        path = path,
    )

def application(
    name,
    infoplist,
    deps = [],
    test_deps = [],
    app_test_deps = [],
    ):
    # Library with the code of the app, plus an associated unit test target without host app
    first_party_library(
        name = name,
        deps = deps,
        test_deps = test_deps,
    )

    swift_app_test_srcs = native.glob(swift_app_test_srcs_glob)
    if len(swift_app_test_srcs) > 0:
        # Test library with a host app, so tests that require an app running can be executed
        swift_test_interface(
            name = generate_app_tests_name(name),
            deps = [":" + name] + app_test_deps,
            srcs = swift_app_test_srcs,
            host_app = ":" + generate_app_name(name),
        )

    # The application bundle
    application_interface(
        name = generate_app_name(name),
        infoplist = infoplist,
        main_target = ":" + name,
        deps = deps,
    )