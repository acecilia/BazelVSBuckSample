<p align="center">
  <a href="https://dev.azure.com/acecilia/BazelVSBuckSample/_build/latest?definitionId=1&branchName=master">
    <img src="https://dev.azure.com/acecilia/BazelVSBuckSample/_apis/build/status/acecilia.BazelVSBuckSample?branchName=master"/>
  </a>
</p>

# Bazel VS Buck Sample

A repository with several iOS examples built with Bazel and Buck.

To see their differences in terms of source code, compare the content of the [bazel configuration folder](config/bazel_config) with the [buck configuration folder](config/buck_config).

To see their difference in terms of performance, refer to the [latest build in the CI server](https://dev.azure.com/acecilia/BazelVSBuckSample/_build/latest?definitionId=1&branchName=master).

# Main differences

Major problems without a workaround are marked with the ⛔ emoji:

* 02/10/2019 - Buck rule `prebuilt_apple_framework` does not copy dynamic libraries into the final bundle  
[[Buck Reference](https://github.com/facebook/buck/issues/2058)]  
[[Workaround implemented](https://github.com/acecilia/BazelVSBuckSample/blob/master/config/buck_config/rule_interfaces.bzl#L10)]
* 02/10/2019 - Buck does not cache test results, bazel does  
[[Buck Reference](https://github.com/facebook/buck/issues/2320)]  
[No workaround available] ⛔
* 02/10/2019 - Bazel does not support an objc library as dependency of another objc library, buck does  
[[Bazel Reference](https://github.com/bazelbuild/bazel/issues/9461)]  
[[Buck Reference](https://buck.build/rule/apple_library.html#exported_headers)]  
[[Workaround implemented](https://github.com/acecilia/BazelVSBuckSample/blob/master/config/bazel_config/rule_interfaces.bzl#L46)]
* 06/10/2019 - Buck does not support adding/distributing/reusing custom rules/macros, bazel does  
[[Bazel reference](https://github.com/bazelbuild/bazel/issues/7057#issuecomment-538701347)]  
[[Buck reference](https://buck.build/extending/rules.html)]  
[No workaround available] ⛔
* 06/10/2019 - A consecuence of the previous point: bazel takes a long time setting up when doing a clean build, because it needs to fetch the rules and dependencies specified in the workspace  
[No workaround available, but not a major issue, as clean builds are rare]
* 06/10/2019 - Buck test runner ([xctool](https://github.com/facebook/xctool)) reuses the same simulator for all tests and can use an already booted simulator. Bazel test runner ([xctestrunner](https://github.com/google/xctestrunner)) creates a new simulator for every test suite and does not allow to use an already booted one. As a result, the tests results from bazel are more reliable but slower  
[[Bazel reference](https://github.com/bazelbuild/rules_apple/issues/607#issuecomment-532280429)]  
[No workaround available, but not a major issue, as both test runners perform good enough]
* 08/10/2019 - Buck does not support making bundles for resources, bazel does. This is necessary in order to prevent resource name collisions, which can happen if the resources are copied to the main bundle directly without placing them inside a bundle  
[[Bazel reference](https://github.com/bazelbuild/rules_apple/blob/master/doc/rules-resources.md#apple_resource_bundle)]  
[[Buck reference](https://github.com/facebook/buck/issues/1483)]  
[[Workaround implemented](https://github.com/acecilia/BazelVSBuckSample/blob/master/config/buck_config/rule_interfaces.bzl#L33)]

# References

* https://github.com/lyft/envoy-mobile
* https://github.com/airbnb/BuckSample
* https://github.com/material-components/material-components-ios
