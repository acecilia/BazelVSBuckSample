load("//config:constants.bzl", "SWIFT_VERSION", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX")

build_system = "buck"

# The prebuilt dependencies in buck have to be passed as dependencies of the apple_bundle rule
# See: 
# - https://github.com/facebook/buck/issues/2058
# - https://github.com/airbnb/BuckSample/blob/24472210a105f7e3a5e71842ed79cae7bbc6e07e/Libraries/SwiftWithPrecompiledDependency/BUCK#L9
prebuilt_dependencies_hack = [
    "//Carthage:CocoaLumberjack",
    "//Carthage:FileKit",
]

def exports_files_interface(
    files,
    ):
    for file in files:
        basename = file.split('/')[::-1][0]
        native.genrule(
            name = file,
            srcs = [file],
            out = basename,
            cmd = "cp $SRCDIR/" + file + " $OUT",
            visibility = ["PUBLIC"],
        )

def resources_group_interface(
    name,
    files,
    ):
    native.apple_resource(
        name = name,
        files = files,
    )

# A common interface for a swift or objc library
def apple_library_interface(
    name,
    srcs,
    headers,
    deps,
    resources_rule,
    swift_version,
    ):
    # In buck, resources are used as dependencies. See: https://buck.build/rule/apple_resource.html
    if resources_rule != None:
        deps = deps + [":" + resources_rule]

    native.apple_library(
        name = name,
        srcs = srcs,
        exported_headers = headers,
        modular = True,
        deps = deps,
        swift_version = swift_version,
        visibility = ["PUBLIC"],
    )

def objc_library_interface(
    name,
    srcs,
    headers,
    deps,
    resources_rule = None,
    ):
    apple_library_interface(
        name = name,
        srcs = srcs,
        headers = headers,
        deps = deps,
        resources_rule = resources_rule,
        swift_version = None,
    )

def swift_library_interface(
    name,
    srcs,
    deps,
    resources_rule = None,
    ):
    apple_library_interface(
        name = name,
        srcs = srcs,
        headers = None,
        deps = deps,
        resources_rule = resources_rule,
        swift_version = SWIFT_VERSION,
    )

def apple_test_interface(
    name,
    srcs,
    deps,
    host_app,
    swift_version,
    ):
    deps = deps + prebuilt_dependencies_hack

    native.apple_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        frameworks = [
          "$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework"
        ],
        info_plist = '//Libraries/HostApp:Info.plist',
        info_plist_substitutions = {
            "EXECUTABLE_NAME": name,
            "PRODUCT_BUNDLE_IDENTIFIER": PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
            "PRODUCT_NAME": name,
        },
        test_host_app = host_app,
        swift_version = swift_version,
    )

def objc_test_interface(
    name,
    srcs,
    deps,
    host_app = None,
    ):
    apple_test_interface(
        name = name,
        srcs = srcs,
        deps = deps,
        host_app = host_app,
        swift_version = None,
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    host_app = None,
    ):
    apple_test_interface(
        name = name,
        srcs = srcs,
        deps = deps,
        host_app = host_app,
        swift_version = SWIFT_VERSION,
    )

def prebuilt_dynamic_framework_interface(
    name,
    path,
    ):
    native.prebuilt_apple_framework(
        name = name,
        framework = path,
        preferred_linkage = "shared",
        visibility = ["PUBLIC"],
    )

def application_interface(
    name,
    infoplist,
    main_target,
    strip_unused_symbols = True,
    ):
    linker_flags = None
    if strip_unused_symbols == False:
        linker_flags = ["-all_load"]

    binary_name = name + "Binary"
    native.apple_binary(
        name = binary_name,
        srcs = [],
        deps = [main_target],
        linker_flags = linker_flags,
    )

    native.apple_bundle(
        name = name,
        extension = "app",
        binary = ":" + binary_name,
        info_plist = infoplist,
        info_plist_substitutions = {
            "EXECUTABLE_NAME": name,
            "PRODUCT_BUNDLE_IDENTIFIER": PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
            "PRODUCT_NAME": name,
        },
        deps = prebuilt_dependencies_hack,
        visibility = ["PUBLIC"],
    )

    native.apple_package(
        name = name + "Package",
        bundle = ":" + name,
    )