# This file includes several macros to easily setup your build system
# The logic in this file is builtool agnostic

# The rule_interfaces.bzl is the file that contains the concrete implementation 
# of the rules for the different buildtools
load(
    "//config/selected_config:rule_interfaces.bzl", 
    "build_system",
    "exports_files_interface",
    "resources_group_interface",
    "objc_library_interface",
    "objc_test_interface",
    "swift_library_interface", 
    "swift_test_interface", 
    "prebuilt_dynamic_framework_interface",
    "application_interface"
    )

# Constants
sources_path = "Sources"
tests_path = "Tests"
app_tests_path = "AppTests"
resources_path = "Resources"

any_file_suffix = "/**/*"

# Swift source files
swift_files_suffix = "/**/*.swift"
def swift_srcs(): return native.glob([sources_path + swift_files_suffix])
def swift_test_srcs(): return native.glob([tests_path + swift_files_suffix])
def swift_app_test_srcs(): return native.glob([app_tests_path + swift_files_suffix])

# Objective-c source files
objc_files_suffix = "/**/*.m"
def objc_srcs(): return native.glob([sources_path + objc_files_suffix])
def objc_test_srcs(): return native.glob([tests_path + objc_files_suffix])
def objc_app_test_srcs(): return native.glob([app_tests_path + objc_files_suffix])

# Objective-c headers files
objc_headers_suffix = "/**/*.h"
def objc_headers(): return native.glob([sources_path + objc_headers_suffix])

# Resources
def resource_files(): return native.glob([resources_path + any_file_suffix])

# Target names
def resources_name(name): return name + resources_path
def swift_tests_name(name): return name + tests_path
def swift_app_tests_name(name): return name + app_tests_path
def objc_tests_name(name): return name + "Objc" + tests_path
def objc_app_tests_name(name): return name + "Objc" + app_tests_path
def app_name(name): return name + "Bundle"

# Macros
def first_party_library(
    name,
    deps = [],
    test_deps = [],
    app_test_deps = [],
    host_app = None,
    ):
    resources_rule = None
    if len(resource_files()) > 0:
        resources_group_interface(
            name = resources_name(name),
            files = resource_files(),
        )
        resources_rule = resources_name(name)

    # The main target has to be swift or objc, not both
    if len(swift_srcs()) > 0:
        swift_library_interface(
            name = name,
            srcs = swift_srcs(),
            deps = deps,
            resources_rule = resources_rule,
        )

    if len(objc_srcs()) > 0:
        objc_library_interface(
            name = name,
            srcs = objc_srcs(),
            headers = objc_headers(),
            deps = deps,
            resources_rule = resources_rule,
        )

    # The test targets can be swift, objc or both
    test_deps = [":" + name] + test_deps
    if len(swift_test_srcs()) > 0:
        swift_test_interface(
            name = swift_tests_name(name),
            deps = test_deps,
            srcs = swift_test_srcs(),
        )

    if len(objc_test_srcs()) > 0:
        objc_test_interface(
            name = objc_tests_name(name),
            deps = test_deps,
            srcs = objc_test_srcs(),
        )

    # The app test targets can be swift, objc or both
    app_test_deps = [":" + name] + app_test_deps
    if len(swift_app_test_srcs()) > 0:
        swift_test_interface(
            name = swift_app_tests_name(name),
            deps = app_test_deps,
            srcs = swift_app_test_srcs(),
            host_app = create_host_app_if_needed(name, deps, host_app),
        )

    if len(objc_app_test_srcs()) > 0:
        objc_test_interface(
            name = objc_app_tests_name(name),
            deps = app_test_deps,
            srcs = objc_app_test_srcs(),
            host_app = create_host_app_if_needed(name, deps, host_app),
        )

def create_host_app_if_needed(
    name,
    deps,
    host_app,
    ):
    if host_app == None:
        host_app_name = name + "HostApp"
        host_app_lib_name = host_app_name + "Lib"

        swift_library_interface(
            name = host_app_lib_name,
            srcs = ["//Libraries/HostApp:Sources/AppDelegate.swift"],
            deps = [":" + name] + deps,
        )

        # - strip_unused_symbols: when testing a library inside an app, by default the unused symbols are
        #   removed from the binary. If the binary needs to be tested, the symbols are needed to avoid the
        #   linker error 'ld: symbol(s) not found for architecture ...'
        application_interface(
            name = host_app_name,
            infoplist = "//Libraries/HostApp:Info.plist",
            main_target = ":" + host_app_lib_name,
            strip_unused_symbols = False, 
        )
        host_app = ":" + host_app_name

    return host_app

def application(
    name,
    infoplist,
    deps = [],
    test_deps = [],
    app_test_deps = [],
    ):
    # Library with the code of the app
    first_party_library(
        name = name,
        deps = deps,
        test_deps = test_deps,
        app_test_deps = app_test_deps,
        host_app = ":" + app_name(name),
    )

    # The application bundle
    application_interface(
        name = app_name(name),
        infoplist = infoplist,
        main_target = ":" + name,
    )

def prebuilt_dynamic_framework(
    path,
    ):
    basename_without_extension = path.replace('.', '/').split('/')[::-1][1]
    prebuilt_dynamic_framework_interface(
        name = basename_without_extension,
        path = path,
    )

def exports_files(
    files,
    ):
    exports_files_interface(
        files = files
    )
