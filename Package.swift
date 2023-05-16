// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "swift-science",
    products: [
        .library(name: "Science", targets: ["Science"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0")
    ],
    targets: [
        .target(name: "Science", dependencies: [.product(name: "Numerics", package: "swift-numerics")]),
        .testTarget(name: "ScienceTests", dependencies: ["Science"])
    ]
)
