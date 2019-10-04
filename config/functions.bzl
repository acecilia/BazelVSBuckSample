def get_basename(path):
    return path.split('/')[::-1][0]

def get_basename_without_extension(path):
    return path.replace('.', '/').split('/')[::-1][1]

def merge_dictionaries(a, b):
    d = {}
    d.update(a)
    d.update(b)
    return d