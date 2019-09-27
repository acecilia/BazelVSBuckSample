load("@rules_cc//cc:defs.bzl", "objc_library")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test", "ios_application")
load("@build_bazel_rules_apple//apple:apple.bzl", "apple_dynamic_framework_import")
load("//config:constants.bzl", "MINIMUM_OS_VERSION", "SWIFT_VERSION", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX")

build_system = "bazel"

def objc_library_interface(
    name,
    srcs,
    headers,
    deps,
    ):
    objc_library(
        name = name,
        srcs = srcs,
        hdrs = headers,
        deps = deps,
        module_name = name,
        visibility = ["//visibility:public"],
    )

def swift_library_interface(
    name,
    srcs,
    deps,
    ):
    swift_library(
        name = name,
        srcs = srcs,
        deps = deps,
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
    deps,
    ):
    ios_application(
        name = name,
        bundle_id = PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
        families = ["iphone", "ipad",],
        infoplists = [infoplist],
        minimum_os_version = MINIMUM_OS_VERSION,
        deps = [main_target] + deps,
    )