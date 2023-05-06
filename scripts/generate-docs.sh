swift package \
    --allow-writing-to-directory docs \
    generate-documentation \
    --target Science \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path swift-science \
    --output-path docs
