# Constants
srcs_glob = ["Sources/**/*.swift"]
test_srcs_glob = ["Tests/**/*.swift"]

# Functions
def generate_test_name(name): 
    return name + "Tests"

# Macros
def first_party_library(
    name,
    deps = [],
    test_deps = [],
    ):
    srcs = native.glob(srcs_glob)
    native.apple_library(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
    )

    test_name = generate_test_name(name)
    test_srcs = native.glob(test_srcs_glob)
    native.apple_test(
        name = test_name,
        module_name = test_name,
        deps = [":" + name] + test_deps,
        srcs = test_srcs,
        frameworks = [
          "$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework"
        ],
        info_plist = "//buck_config:info_plist",
        info_plist_substitutions = {
            "CURRENT_PROJECT_VERSION": "1",
            "DEVELOPMENT_LANGUAGE": "English",
            "EXECUTABLE_NAME": test_name,
            "PRODUCT_BUNDLE_IDENTIFIER": "com.company." + test_name,
            "PRODUCT_NAME": test_name,
        },
    )