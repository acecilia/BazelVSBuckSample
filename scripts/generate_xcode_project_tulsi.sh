set -eou pipefail

##############################################################
# Get all targets in the repository that need to be added to the Xcode project 
##############################################################

# Get targets list + add quotes and comas at start and end of line
targets_list=$(make list BUILDTOOL=bazel | sed 's/^/"/; s/$/",/')
# Remove spaces + Add new lines + add indentation + escape backslashes
targets_list=$(echo $targets_list | sed 's/ //g' | sed 's/,/,\\n/g' | sed 's/"\/\//\\ \\ \\ \\ "\/\//g' | sed 's/\//\\\//g')

##############################################################
# Add all targets to the tulsiproj files
##############################################################

tulsiproj_path='config/bazel_config/BazelVSBuckSample.tulsiproj'
regex_to_replace='(\"buildTargets\" : \[).*?(\])'
# Replace the targets in the tulsigen file with the new targets
perl -0pi -e "s/$regex_to_replace/\1\n$targets_list  \2/gs" "$tulsiproj_path/Configs/All.tulsigen"

##############################################################
# Generate Xcode project using the newly generated tulsigen
##############################################################

/Applications/Tulsi.app/Contents/MacOS/Tulsi -- --bazel /usr/local/bin/bazel --genconfig "$tulsiproj_path:All"
