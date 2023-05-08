generate-and-preview-docs: generate-docs preview-docs

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


preview-docs:
	swift package --disable-sandbox preview-documentation --target Science
