load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test")

swift_library(
    name = "MainTarget",
    module_name = "MainTarget", // Needed to avoid the prefix introduced by bazel. See the 'module_name' description for more information
    srcs = glob(["Sources/**/*.swift"]),
)

swift_test(
    name = "MainTargetTests",
    deps = [":MainTarget"],
    srcs = glob(["Tests/**/*.swift"]),
)