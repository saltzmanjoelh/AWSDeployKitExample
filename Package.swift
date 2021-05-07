// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeployExample",
    products: [
        .executable(
            name: "example-lambda",
            targets: ["example-lambda"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .branch("main")),
        .package(url: "https://github.com/apple/swift-nio", .branch("main")),
        .package(url: "https://github.com/apple/swift-log", .branch("main")),
        .package(url: "https://github.com/saltzmanjoelh/AWSDeployKit", .branch("main")),
    ],
    targets: [
        .target(
            name: "example-lambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .target(
            name: "Deploy",
            dependencies: [
                .product(name: "AWSDeployCore", package: "AWSDeployKit"),
            ]),
    ]
)
