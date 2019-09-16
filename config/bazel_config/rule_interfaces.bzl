load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_apple//apple:apple.bzl", "apple_dynamic_framework_import")

build_system = "bazel"

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
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    ):
    test_lib_name = name + "Lib"

    swift_library(
        name = test_lib_name,
        srcs = srcs,
        deps = deps,
    )

    ios_unit_test(
        name = name,
        deps = [":" + test_lib_name],
        minimum_os_version = "10.0",
    )

def prebuilt_apple_framework_interface(
    name,
    path,
    ):
    apple_dynamic_framework_import(
        name = name,
        framework_imports = native.glob([path + "/**",]),
        visibility = ["//visibility:public"],
    )