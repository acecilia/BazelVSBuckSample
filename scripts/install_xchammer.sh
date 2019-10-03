set -eou pipefail

# Clone XCHammer repository
download_dir="tools/xchammer"
rm -rf "$download_dir"
mkdir -p "$download_dir"
git clone "https://github.com/pinterest/xchammer" "$download_dir"
cd "$download_dir"
git checkout f5fe4657eb751ababfa4ad5986afaa691910080f

# Install XCHammer
make archive
install_path=/usr/local/bin
# XCHammer does not work properly if the binary is moved out of the repository where it was built
# As a solution, add a symlink to it in the install path
ln -fs "$(pwd)/xchammer.app/Contents/MacOS/xchammer" "$install_path/xchammer"

# Finish
xchammer_version=$(xchammer version)
echo "XCHammer version '$xchammer_version' installed at path '$install_path'"