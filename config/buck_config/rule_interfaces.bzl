load("//config:constants.bzl", "SWIFT_VERSION", "PRODUCT_BUNDLE_IDENTIFIER_PREFIX", "SWIFT_DEBUG_COMPILER_FLAGS")
load("//config:functions.bzl", "get_basename")
load("//config/buck_config:buck.bzl", "plist_substitutions", "xcode_library_configs", "xcode_app_configs")

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
        basename = get_basename(file)
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
    bundled,
    ):
    if bundled:
        # Buck does not support generating a resources bundle: using a genrule is a workaround
        # See: https://github.com/facebook/buck/issues/1483
        genrule_name = name + "GenRule"
        native.genrule(
            name = genrule_name,
            srcs = files,
            out = name + ".bundle",
            cmd = "mkdir $OUT && cp $SRCS $OUT",
        )
        native.apple_resource(
            name = name,
            dirs = [":" + genrule_name],
        )
    else:
        native.apple_resource(
            name = name,
            files = files,
        )

# A common interface for a swift or objc library
def _apple_library_interface(
    name,
    tests,
    srcs,
    headers,
    deps,
    swift_compiler_flags,
    swift_version,
    resources,
    ):
    # In buck, resources are used as dependencies. See: https://buck.build/rule/apple_resource.html
    deps = deps + resources

    native.apple_library(
        name = name,
        tests = tests,
        srcs = srcs,
        exported_headers = headers,
        modular = True,
        deps = deps,
        swift_version = swift_version,
        visibility = ["PUBLIC"],
        configs = xcode_library_configs(name),
        swift_compiler_flags = swift_compiler_flags,
    )

def objc_library_interface(
    name,
    tests,
    srcs,
    headers,
    deps,
    resources,
    ):
    _apple_library_interface(
        name = name,
        tests = tests,
        srcs = srcs,
        headers = headers,
        deps = deps,
        swift_compiler_flags = None,
        swift_version = None,
        resources = resources,
    )

def swift_library_interface(
    name,
    tests,
    srcs,
    deps,
    swift_compiler_flags,
    swift_version,
    resources,
    ):
    _apple_library_interface(
        name = name,
        tests = tests,
        srcs = srcs,
        headers = None,
        deps = deps,
        swift_compiler_flags = swift_compiler_flags,
        swift_version = swift_version,
        resources = resources,
    )

def _apple_test_interface(
    name,
    srcs,
    deps,
    swift_compiler_flags,
    swift_version,
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
        info_plist = '//Support/Files:Info.plist',
        info_plist_substitutions = plist_substitutions(name),
        test_host_app = host_app,
        swift_version = swift_version,
        swift_compiler_flags = swift_compiler_flags,
        configs = xcode_library_configs(name),
    )

def objc_test_interface(
    name,
    srcs,
    deps,
    host_app,
    ):
    _apple_test_interface(
        name = name,
        srcs = srcs,
        deps = deps,
        swift_compiler_flags = None,
        swift_version = None,
        host_app = host_app,
    )

def swift_test_interface(
    name,
    srcs,
    deps,
    swift_version,
    host_app,
    ):
    _apple_test_interface(
        name = name,
        srcs = srcs,
        deps = deps,
        swift_compiler_flags = SWIFT_DEBUG_COMPILER_FLAGS,
        swift_version = swift_version,
        host_app = host_app,
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
    strip_unused_symbols,
    ):
    linker_flags = None
    if strip_unused_symbols == False:
        linker_flags = ["-all_load"]

    binary_name = name + "Binary"
    native.apple_binary(
        name = binary_name,
        # We need a dummy source here for the generated xcode project to work, otherwise
        # xcode shows an error saying 'Build input file cannot be found: '...SwiftAppBundle.app/SwiftAppBundle''
        srcs = ["//Support/Files:Dummy.swift"],
        deps = [main_target],
        linker_flags = linker_flags,
        swift_version = SWIFT_VERSION, # Any swift version will work here, as the dummy file is empty
        configs = xcode_app_configs(name),
    )

    native.apple_bundle(
        name = name,
        extension = "app",
        binary = ":" + binary_name,
        info_plist = infoplist,
        info_plist_substitutions = plist_substitutions(name),
        deps = prebuilt_dependencies_hack,
        visibility = ["PUBLIC"],
    )

    native.apple_package(
        name = name + "Package",
        bundle = ":" + name,
    )