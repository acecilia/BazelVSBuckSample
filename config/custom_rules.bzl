# This file includes several macros to easily setup your build system
# The logic in this file is builtool agnostic

# The rule_interfaces.bzl is the file that contains the concrete implementation 
# of the rules for the different buildtools
load(
    "//config/selected_config:rule_interfaces.bzl", 
    "build_system",
    "objc_library_interface",
    "objc_test_interface",
    "swift_library_interface", 
    "swift_test_interface", 
    "prebuilt_dynamic_framework_interface",
    "application_interface"
    )

# Constants
main_code_path = "Sources"
swift_test_code_path = "Tests"
objc_test_code_path = "ObjcTests"
swift_app_test_code_path = "AppTests"
objc_app_test_code_path = "ObjcAppTests"

# swift
swift_files_suffix = "/**/*.swift"
swift_srcs_glob = [main_code_path + swift_files_suffix]
swift_test_srcs_glob = [swift_test_code_path + swift_files_suffix]
swift_app_test_srcs_glob = [swift_app_test_code_path + swift_files_suffix]

# objective-c
objc_files_suffix = "/**/*.m"
objc_srcs_glob = [main_code_path + objc_files_suffix]
objc_test_srcs_glob = [objc_test_code_path + objc_files_suffix]
objc_app_test_srcs_glob = [objc_app_test_code_path + objc_files_suffix]

# objective-c headers
objc_headers_suffix = "/**/*.h"
objc_headers_glob = [main_code_path + objc_headers_suffix]

# Functions
def generate_swift_tests_name(name): 
    return name + swift_test_code_path

def generate_swift_app_tests_name(name): 
    return name + swift_app_test_code_path

def generate_objc_tests_name(name): 
    return name + objc_test_code_path

def generate_objc_app_tests_name(name): 
    return name + objc_app_test_code_path

def generate_app_name(name): 
    return name + "Bundle"

# Macros
def first_party_library(
    name,
    deps = [],
    test_deps = [],
    ):
    # The main target has to be swift or objc, not both
    swift_srcs = native.glob(swift_srcs_glob)
    if len(swift_srcs) > 0:
        swift_library_interface(
            name = name,
            srcs = swift_srcs,
            deps = deps,
        )

    objc_srcs = native.glob(objc_srcs_glob)
    if len(objc_srcs) > 0:
        objc_library_interface(
            name = name,
            srcs = objc_srcs,
            headers = native.glob(objc_headers_glob),
            deps = deps,
        )

    # The test targets can be swift, objc or both
    test_deps = [":" + name] + test_deps
    swift_test_srcs = native.glob(swift_test_srcs_glob)
    if len(swift_test_srcs) > 0:
        swift_test_interface(
            name = generate_swift_tests_name(name),
            deps = test_deps,
            srcs = swift_test_srcs,
        )

    objc_test_srcs = native.glob(objc_test_srcs_glob)
    if len(objc_test_srcs) > 0:
        objc_test_interface(
            name = generate_objc_tests_name(name),
            deps = test_deps,
            srcs = objc_test_srcs,
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
            name = generate_swift_app_tests_name(name),
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