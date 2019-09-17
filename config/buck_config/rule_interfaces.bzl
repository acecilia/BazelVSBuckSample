load("//config:constants.bzl", "SWIFT_VERSION")

build_system = "buck"

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
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    host_app = None,
    ):
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
            "PRODUCT_BUNDLE_IDENTIFIER": "com.company." + name,
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

    native.apple_bundle(
        name = name,
        extension = "app",
        binary = ":" + binary_name,
        info_plist = infoplist,
        info_plist_substitutions = {
            "EXECUTABLE_NAME": name,
            "PRODUCT_BUNDLE_IDENTIFIER": "com.example." + name,
            "PRODUCT_NAME": name,
        },
        deps = deps,
    )