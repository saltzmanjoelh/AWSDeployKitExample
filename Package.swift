// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeployExample",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "example-lambda",
            targets: ["example-lambda"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .branch("main")),
        .package(url: "https://github.com/saltzmanjoelh/aws-deploy-kit", .branch("main")),
    ],
    targets: [
        .target(
            name: "example-lambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ]),
        .target(
            name: "Deploy",
            dependencies: [
                .product(name: "AWSDeployCore", package: "aws-deploy-kit"),
            ]),
    ]
)
