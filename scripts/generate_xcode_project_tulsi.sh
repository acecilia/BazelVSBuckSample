set -eou pipefail

##############################################################
# Constants
##############################################################

tulsi="/Applications/Tulsi.app/Contents/MacOS/Tulsi"
output_path="config/bazel_config"
tulsiproj_path="$output_path/BazelVSBuckSample.tulsiproj"
tulsiconf_path="$tulsiproj_path/project.tulsiconf"
tulsigen_path="$tulsiproj_path/Configs/BazelVSBuckSample.tulsigen"

##############################################################
# Get all targets in the repository that need to be added to the Xcode project 
##############################################################

# Get targets list + add target flags
targets_list=$(make list BUILDTOOL=bazel | sed 's/^/--target /;')

##############################################################
# Generate tulsiproj
# See: https://github.com/bazelbuild/tulsi/issues/104
##############################################################

"$tulsi" -- \
--create-tulsiproj "BazelVSBuckSample" \
--bazel "/usr/local/bin/bazel" \
--outputfolder "config/bazel_config" $targets_list

##############################################################
# Patch generated tulsiproj
##############################################################

# Remove the 'additionalFilePaths'
regex_to_replace='\  "additionalFilePaths\".*?\],\n'
perl -0pi -e "s/$regex_to_replace//gs" "$tulsigen_path"

# Fix the 'sourceFilters': using './...' does not include the 'Sources' directories
# in the Xcode project ( no idea why). Using '//Libraries/...' fixes the problem
perl -pi -e 's|\Q./...|//Libraries/...|g' "$tulsigen_path"

# Remove the 'packages' from the tulsiconf file because every time they are
# generated the sorting is different and messes up with version control.
# Seems like removing them does not have any negative effect
regex_to_replace='\  "packages\".*?\],\n'
perl -0pi -e "s/$regex_to_replace//gs" "$tulsiconf_path"

##############################################################
# Generate Xcode project using the newly generated tulsiproj
##############################################################

"$tulsi" -- \
--genconfig "$tulsiproj_path"

