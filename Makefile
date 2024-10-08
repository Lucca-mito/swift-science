MAKEFLAGS += --silent

# Invoke by just running `make`. Note that this builds the project twice.
generate-and-preview-docs: generate-docs preview-docs

# Build the documentation website and write it to the docs directory. For this build, SwiftPM is sandboxed.
generate-docs:
	swift package \
	--allow-writing-to-directory docs \
	generate-documentation \
	--target Science \
	--include-extended-types \
	--disable-indexing \
	--transform-for-static-hosting \
	--hosting-base-path swift-science \
	--output-path docs \
	--source-service github \
	--source-service-base-url https://github.com/lucca-mito/swift-science/blob/main \
	--checkout-path "$(PWD)"

# Build the documentation website but don't update the docs directory. For this build, SwiftPM cannot be sandboxed.
preview-docs:
	swift package \
	--disable-sandbox \
	preview-documentation \
	--target Science \
	--include-extended-types \
	--source-service github \
	--source-service-base-url https://github.com/lucca-mito/swift-science/blob/main \
	--checkout-path "$(PWD)"
