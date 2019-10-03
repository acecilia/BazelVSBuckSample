set -eou pipefail



xctool_destination="$(pwd)/tools/xctool"

# Clone XCTool repository
tmp_dir=$(mktemp -d -t xctool-XXXXXXXXXX)
git clone "https://github.com/facebook/xctool" "$tmp_dir"
cd "$tmp_dir"

# This script only works with Xcode 10.3, because this version of xctool fails building with Xcode 11.
# sudo xcode-select -s /Applications/Xcode10.3.app
git checkout d26dcd451a45bf2eaced1a4051a048ad0fa0833c # Version containing this PR: https://github.com/facebook/xctool/pull/767

# Archive XCTool
# This code is copied from the scripts/make_release.sh script inside the xctool repository
########################
# Start
######################## 
XCTOOL_DIR=$(cd $(dirname $0)/..; pwd)

OUTPUT_DIR=$(mktemp -d -t xctool-release)
BUILD_OUTPUT_DIR="$OUTPUT_DIR"/build
RELEASE_OUTPUT_DIR="$OUTPUT_DIR"/release

xcodebuild \
  build-for-testing \
  -workspace "$XCTOOL_DIR"/xctool.xcworkspace \
  -scheme xctool \
  -configuration Release \
  -IDEBuildLocationStyle=Custom \
  -IDECustomBuildLocationType=Absolute \
  -IDECustomBuildProductsPath="$BUILD_OUTPUT_DIR/Products" \
  -IDECustomBuildIntermediatesPath="$BUILD_OUTPUT_DIR/Intermediates" \
  XT_INSTALL_ROOT="$RELEASE_OUTPUT_DIR"

if [[ ! -x "$RELEASE_OUTPUT_DIR"/bin/xctool ]]; then
  echo "ERROR: xctool binary is missing."
  exit 1
fi
########################
# End
######################## 

# Move the xctool files to the proper destination
cp -fR "$RELEASE_OUTPUT_DIR/." "$xctool_destination"