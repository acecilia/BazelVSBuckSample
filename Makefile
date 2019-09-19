# Make all targets phony. See: https://stackoverflow.com/a/44499287
.PHONY: setup_config $(MAKECMDGOALS)

# Do not print commands being executed
MAKEFLAGS = --silent

ifndef BUILDTOOL
	export BUILDTOOL=buck
endif

export ipa_output_path=products
export bazel_output_path=bazel-bin/Libraries/SwiftApp/SwiftAppBundle.ipa
export buck_output_path=buck-out/gen/Libraries/SwiftApp/SwiftAppBundlePackage.ipa

export extracted_ipa_output_path=products/extracted

setup_config:
# Setup the configuration depending on the build tool
	rm -rf config/selected_config && ln -s $(BUILDTOOL)_config config/selected_config

build: setup_config
# Build all targets recursively
	$(BUILDTOOL) build //Libraries/...

test: setup_config
# Test all targets recursively
	$(BUILDTOOL) test //Libraries/...

run: setup_config
# Run the app in the simulator
ifeq ($(BUILDTOOL),buck)
	$(BUILDTOOL) install --run --simulator-name "iPhone X" //Libraries/SwiftApp:SwiftAppBundle
else
	$(BUILDTOOL) run //Libraries/SwiftApp:SwiftAppBundle
endif

export_ipa: setup_config
# Export the app into an ipa
	mkdir -p "$(ipa_output_path)"
	$(BUILDTOOL) build //Libraries/SwiftApp/...
	cp -f "$($(BUILDTOOL)_output_path)" "$(ipa_output_path)/$(BUILDTOOL).ipa"

extract_ipa: setup_config
# Extract the content of the ipa, so it is possible to inspect it
	mkdir -p "$(extracted_ipa_output_path)"
	unzip -qa "$(ipa_output_path)/$(BUILDTOOL).ipa" -d "$(ipa_output_path)/$(BUILDTOOL)"
	mv "$(ipa_output_path)/$(BUILDTOOL)/Payload/SwiftAppBundle.app" "$(extracted_ipa_output_path)/$(BUILDTOOL)"
	rm -rf "$(ipa_output_path)/$(BUILDTOOL)"

list: setup_config
# List all targets
ifeq ($(BUILDTOOL),buck)
	$(BUILDTOOL) targets //Libraries/...
else
	$(BUILDTOOL) query //Libraries/...
endif

clean: setup_config
	$(BUILDTOOL) clean

# Actions for all build tools

all_export_ipa:
	rm -rf "$(ipa_output_path)"
	$(MAKE) export_ipa BUILDTOOL=buck
	$(MAKE) export_ipa BUILDTOOL=bazel

all_extract_ipa: all_export_ipa
# Show diff between ipas
	$(MAKE) extract_ipa BUILDTOOL=buck
	$(MAKE) extract_ipa BUILDTOOL=bazel

all_clean:
	$(MAKE) clean BUILDTOOL=buck
	$(MAKE) clean BUILDTOOL=bazel