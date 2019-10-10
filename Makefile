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

install_tools:
	sh scripts/install_tools.sh

build: setup_config
# Build all targets recursively
	$(BUILDTOOL) build //Libraries/...

test: setup_config
# Test all targets recursively
	$(BUILDTOOL) test //Libraries/...

run: setup_config
# Run the app in the simulator
ifeq ($(BUILDTOOL),buck)
	$(BUILDTOOL) install --run --simulator-name "iPhone 8" //Libraries/SwiftApp:SwiftAppApplication
else
	$(BUILDTOOL) run --ios_simulator_device="iPhone 8" --ios_simulator_version="13.0" //Libraries/SwiftApp:SwiftAppApplication
endif

install_tulsi:
	sh scripts/install_tulsi.sh

install_xchammer:
	sh scripts/install_xchammer.sh

project: setup_config clean
ifeq ($(BUILDTOOL),buck)
	# Generate xcode projects for apps and libraries
	$(BUILDTOOL) project $$(buck targets //Libraries/... --type apple_bundle apple_library)
	# Rename shared schemes of the workspaces to All, as what they do is build and test all targets
	find . -path '*.xcworkspace/xcshareddata/xcschemes/*.xcscheme' -execdir mv {} All.xcscheme \;
else
	sh scripts/generate_xcode_project_tulsi.sh
endif

project_xchammer:
	xchammer generate "XCHammer.yaml"

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
# List main targets, filtering out other secondary ones
	$(BUILDTOOL) query 'filter("^.+\/(.*):\1(.*(Tests|AppTests|Application))?$$", //Libraries/...)'	

clean: setup_config
	find . \( -name '*.xcworkspace' -o -name '*.xcodeproj' \) -exec rm -rf {} +
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

all_test:
	$(MAKE) test BUILDTOOL=buck
	$(MAKE) test BUILDTOOL=bazel