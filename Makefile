MAKEFLAGS += --silent

# Builds the project twice. Invoke by just typing make.
generate-and-preview-docs: generate-docs preview-docs

# Build the documentation website and write it to the docs directory. For this build, SwiftPM is sandboxed.
generate-docs:
	swift package \
    --allow-writing-to-directory docs \
    generate-documentation \
    --target Science \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path swift-science \
    --output-path docs \
    --source-service github \
    --source-service-base-url https://github.com/lucca-mito/swift-science/blob/main \
    --checkout-path $(PWD)

# Build the documentation website but don't update the docs directory. For this build, SwiftPM cannot be sandboxed.
preview-docs:
	swift package \
    --disable-sandbox \
    preview-documentation \
    --target Science \
    --source-service github \
    --source-service-base-url https://github.com/lucca-mito/swift-science/blob/main \
    --checkout-path $(PWD)
