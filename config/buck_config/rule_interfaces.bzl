load("//config:constants.bzl", "SWIFT_VERSION", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX")

build_system = "buck"

# This is needed for buck
# See: 
# - https://github.com/facebook/buck/issues/2058
# - https://github.com/airbnb/BuckSample/blob/24472210a105f7e3a5e71842ed79cae7bbc6e07e/Libraries/SwiftWithPrecompiledDependency/BUCK#L9
prebuilt_dependencies_hack = [
    "//Carthage:AFNetworking",
    "//Carthage:FileKit",
]

def swift_library_interface(
    name,
    srcs,
    deps,
    ):
    native.apple_library(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        swift_version = SWIFT_VERSION,
        visibility = ["PUBLIC"],
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    host_app,
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
        info_plist = "//config/buck_config:info_plist",
        info_plist_substitutions = {
            "CURRENT_PROJECT_VERSION": "1",
            "DEVELOPMENT_LANGUAGE": "English",
            "EXECUTABLE_NAME": name,
            "PRODUCT_BUNDLE_IDENTIFIER": PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
            "PRODUCT_NAME": name,
        },
        test_host_app = host_app,
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
    deps,
    ):
    binary_name = name + "Binary"
    native.apple_binary(
        name = binary_name,
        srcs = [],
        deps = [main_target],
    )

    deps = deps + prebuilt_dependencies_hack

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
        deps = deps,
    )

    native.apple_package(
        name = name + "Package",
        bundle = ":" + name,
    )