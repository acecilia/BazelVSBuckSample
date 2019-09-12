load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library", "swift_test")

swift_library(
    name = "MainTarget",
    srcs = glob(["Sources/**/*.swift"]),
)

swift_test(
    name = "MainTargetTests",
    deps = [":MainTarget"],
    srcs = glob(["Tests/**/*.swift"]),
)