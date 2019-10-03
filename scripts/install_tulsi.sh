set -eou pipefail

# Clone tulsi repository
tmp_dir=$(mktemp -d -t tulsi-XXXXXXXXXX)
git clone "https://github.com/bazelbuild/tulsi" "$tmp_dir"
cd "$tmp_dir"
git checkout c4995df81472b5c11abcc736f23fba8ac3eef322 # Version 0.4.272516202.20191002

# Remove Xcode version. See: https://github.com/bazelbuild/tulsi/pull/99
sed -i '' '/10.2.1/d' ".bazelrc"

# Build and install tulsi in /Applications
export HOME=''
. "build_and_run.sh"

# Finish
echo "Tulsi installed at path '$unzip_dir/Tulsi.app'"