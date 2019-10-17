set -eou pipefail

install_path=/usr/local/bin

echo "✨ Install bazel"
curl -L "https://github.com/bazelbuild/bazel/releases/download/1.0.0/bazel-1.0.0-darwin-x86_64" --output "$install_path/bazel"
chmod u+x "$install_path/bazel"

echo "✨ Install buck"
buck_sha=89981e56f44c73e752651cb47162b73fdb54b24c # Release v2019.10.02.01
curl -L "https://jitpack.io/com/github/facebook/buck/$buck_sha/buck-$buck_sha.pex" --output "$install_path/buck"
chmod u+x "$install_path/buck"
