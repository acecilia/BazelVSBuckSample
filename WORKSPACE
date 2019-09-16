load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "a045a436b642c70fb0c10ca84ff0fd2dcbd59cc89100d597a61e8374afafb366",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/0.18.0/rules_apple.0.18.0.tar.gz",
)

# TODO: Restore this back when support for Xcode 11 is added
# See: https://github.com/material-components/material-components-ios/blob/22aabf167607bb55c4c0d643d35fde7466440632/WORKSPACE#L57
http_file(
    name = "xctestrunner",
    executable = 1,
    sha256 = "9e46d5782a9dc7d40bc93c99377c091886c180b8c4ffb9f79a19a58e234cdb09",
    urls = ["https://github.com/google/xctestrunner/releases/download/0.2.10/ios_test_runner.par"],
)

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)

apple_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

load(
    "@com_google_protobuf//:protobuf_deps.bzl",
    "protobuf_deps",
)

protobuf_deps()
