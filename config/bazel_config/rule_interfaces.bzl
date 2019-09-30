load("@rules_cc//cc:defs.bzl", "objc_library")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test", "ios_application")
load("@build_bazel_rules_apple//apple:apple.bzl", "apple_dynamic_framework_import")
load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_group")
load("//config:constants.bzl", "MINIMUM_OS_VERSION", "SWIFT_VERSION", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX")

build_system = "bazel"

def exports_files_interface(
    files,
    ):
    native.exports_files(
        srcs = files,
        visibility = ["//visibility:public"],
    )

def resources_group_interface(
    name,
    files,
    ):
    apple_resource_group(
        name = name,
        resources = files,
    )

def get_data_from(resources_rule): 
    if resources_rule != None:
        return [":" + resources_rule]
    else:
        return []

def objc_library_interface(
    name,
    srcs,
    headers,
    deps,
    resources_rule = None,
    ):
    objc_library(
        name = name,
        srcs = srcs,
        hdrs = headers,
        deps = deps,
        data = get_data_from(resources_rule),
        module_name = name,
        visibility = ["//visibility:public"],
    )

def swift_library_interface(
    name,
    srcs,
    deps,
    resources_rule = None,
    ):
    swift_library(
        name = name,
        srcs = srcs,
        deps = deps,
        data = get_data_from(resources_rule),
        module_name = name,
        copts = ["-swift-version", SWIFT_VERSION],
        visibility = ["//visibility:public"],
    )

def objc_test_interface(
    name,
    srcs,
    deps,
    host_app = None,
    ):
    return
    # For now having objc tests of objc libraries seems not possible. 
    # See: https://github.com/bazelbuild/bazel/pull/5905#issuecomment-535735561

    test_lib_name = name + "Lib"

    objc_library(
        name = test_lib_name,
        srcs = srcs,
        deps = deps,
        # includes = ["Sources"],
        module_name = test_lib_name,
    )

    ios_unit_test(
        name = name,
        deps = [":" + test_lib_name],
        minimum_os_version = MINIMUM_OS_VERSION,
        runner = "//config/bazel_config:test_runner",
        test_host = host_app,
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    host_app = None,
    ):
    test_lib_name = name + "Lib"

    swift_library(
        name = test_lib_name,
        srcs = srcs,
        deps = deps,
        module_name = test_lib_name,
        copts = ["-swift-version", SWIFT_VERSION],
    )

    ios_unit_test(
        name = name,
        deps = [":" + test_lib_name],
        minimum_os_version = MINIMUM_OS_VERSION,
        runner = "//config/bazel_config:test_runner",
        test_host = host_app,
    )

def prebuilt_dynamic_framework_interface(
    name,
    path,
    ):
    apple_dynamic_framework_import(
        name = name,
        framework_imports = native.glob([path + "/**",]),
        visibility = ["//visibility:public"],
    )


def application_interface(
    name,
    infoplist,
    main_target,
    strip_unused_symbols = True,
    ):
    linkopts = []
    if strip_unused_symbols == False:
        linkopts = ["-all_load"]

    ios_application(
        name = name,
        bundle_id = PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
        families = ["iphone", "ipad",],
        infoplists = [infoplist],
        minimum_os_version = MINIMUM_OS_VERSION,
        deps = [main_target],
        linkopts = linkopts,
        visibility = ["//visibility:public"],
    )