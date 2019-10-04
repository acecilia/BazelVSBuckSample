load("//config:constants.bzl", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX")
load("//config:functions.bzl", "merge_dictionaries")

shared_build_settings = {
    # Without this setting, the generated buck Xcode project will fail the build. 
    # See: https://github.com/facebook/buck/blame/master/src/com/facebook/buck/features/apple/project/ProjectGenerator.java#L1701
    #
    # We do not use the approach in https://github.com/facebook/buck/blob/538017bba12f296e57250def81b0d03ad542390f/src/com/facebook/buck/swift/SwiftBuckConfig.java#L32
    # because it applies the build setting only to the target you are building the xcode for, but not others like the host app library
    "SWIFT_WHOLE_MODULE_OPTIMIZATION": "YES",
}

def plist_substitutions(name):
    return {
        "EXECUTABLE_NAME": name,
        "PRODUCT_BUNDLE_IDENTIFIER": PRODUCT_BUNDLE_IDENTIFIER_PREFIX + name,
        "PRODUCT_NAME": name,
    }

# Build settings to be applied to buck generated xcode projects
def xcode_library_configs(name):
    return {
        "Debug": shared_build_settings,
        "Profile": shared_build_settings,
        "Release": shared_build_settings,
    }

def xcode_app_configs(name):
    plist_build_settings = plist_substitutions(name)
    build_settings = merge_dictionaries(shared_build_settings, plist_build_settings)

    return {
        "Debug": build_settings,
        "Profile": build_settings,
        "Release": build_settings,
    }