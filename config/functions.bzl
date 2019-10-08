def get_basename(path):
    return path.split('/')[::-1][0]

def get_basename_without_extension(path):
    return path.replace('.', '/').split('/')[::-1][1]

def merge_dictionaries(a, b):
    d = {}
    d.update(a)
    d.update(b)
    return d

# A function that tells if there are files with the specified extension under the specified path
def contains_files(
    path, 
    extension,
    ):
    return len(native.glob([path + "/**/*." + extension])) > 0

# A function that returns the files under the path with the specified extension
def get_files( 
    package_name,
    path,
    language = None,
    extension = None,
    allowed_extensions = [],
    ):
    if language != None:
        # If language is specified, allow for the files to be under a subdirectory
        secondary_path = path + "/" + language
        if len(native.glob([secondary_path + "/**/*"])) > 0:
            path = secondary_path

    all_files = native.glob([path + "/**/*"])

    if extension != None:
        wanted_files = native.glob([path + "/**/*." + extension])

        # Check that the files under the path match the allowed extensions. If not, throw an error
        # This checks are important to keep the folder structure consistent and clean of leftover files
        allowed_extensions = allowed_extensions + [extension]
        allowed_files = native.glob([path + "/**/.*"]) # Hidden files
        for allowed_extension in allowed_extensions:
            allowed_files = allowed_files + native.glob([path + "/**/*." + allowed_extension])
        unallowed_files = [file for file in all_files if file not in allowed_files]
        if len(unallowed_files) > 0:
            fail("Package '%s': only files with extensions '%s' are allowed under the path '%s'. Offending files: '%s'" %(package_name, ", ".join(allowed_extensions), path, ", ".join(unallowed_files)))
    else:
        wanted_files = all_files

    return wanted_files