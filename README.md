<p align="center">
  <a href="https://dev.azure.com/acecilia/BazelVSBuckSample/_build/latest?definitionId=1&branchName=master">
    <img src="https://dev.azure.com/acecilia/BazelVSBuckSample/_apis/build/status/acecilia.BazelVSBuckSample?branchName=master"/>
  </a>
</p>

# Bazel VS Buck Sample

A repository with several iOS examples built with Bazel and Buck.

To see their differences in terms of source code, compare the content of the [bazel configuration folder](config/bazel_config) with the [buck configuration folder](config/buck_config).

To see their difference in terms of performance, refer to the [latest build in the CI server](https://dev.azure.com/acecilia/BazelVSBuckSample/_build/latest?definitionId=1&branchName=master).

# Main issues

* [02/10/2019] Buck rule `prebuilt_apple_framework` does not copy dynamic libraries into the final bundle. See: https://github.com/facebook/buck/issues/2058
* [02/10/2019] Buck does not cache test results. See: https://github.com/facebook/buck/issues/2320
* [02/10/2019] Bazel does not support an objc library as dependency of another objc library. See: https://github.com/bazelbuild/bazel/issues/9461

# References

* https://github.com/lyft/envoy-mobile
* https://github.com/airbnb/BuckSample
* https://github.com/material-components/material-components-ios
