set -eou pipefail

# Clone XCHammer repository
tmp_dir=$(mktemp -d -t xchammer-XXXXXXXXXX)
git clone https://github.com/pinterest/xchammer $tmp_dir
cd $tmp_dir
git checkout a2beaea701ad9ef2c50c764d7b58df1ffc090a2a

# Install XCHammer
make archive
install_path=/usr/local/bin/xchammer
cp -f "xchammer.app/Contents/MacOS/xchammer" "$install_path"

# Finish
xchammer_version=$(xchammer version)
echo "XCHammer version '$xchammer_version' installed at path '$install_path'"