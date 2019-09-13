def swift_library_target(
    name,
    srcs,
    deps,
    ):
    native.apple_library(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
    )

def swift_test_target(
    name,
    srcs,
    deps,
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
    )