load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test")
load("@build_bazel_rules_apple//apple:apple.bzl", "apple_dynamic_framework_import")

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
    swift_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        linkopts = ["-F../../../../../../../../../../Users/andres/Git/BazelSample/Carthage/Build/iOS"],
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
