set -eou pipefail

install_path=/usr/local/bin

echo "✨ Install bazel"
curl -L "https://github.com/bazelbuild/bazel/releases/download/0.29.1/bazel-0.29.1-darwin-x86_64" --output "$install_path/bazel"
chmod u+x "$install_path/bazel"

echo "✨ Install buck"
buck_sha=468c76dd0c1eefbc821f4e728e8ed97dfd8978f7 # Release v2019.09.12.01
curl -L "https://jitpack.io/com/github/facebook/buck/$buck_sha/buck-$buck_sha.pex" --output "$install_path/buck"
chmod u+x "$install_path/buck"
