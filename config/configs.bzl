load(
    "//config:constants.bzl", 
    "SWIFT_DEBUG_COMPILER_FLAGS",
    )

# This function switches the compiler flags according to the configuration
def swift_library_compiler_flags():
    # TODO: change flags depending on configuration
    return SWIFT_DEBUG_COMPILER_FLAGS