// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BasicExample",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "example-lambda",
            targets: ["example-lambda"]
        ),
        .executable(
            name: "Deploy",
            targets: ["Deploy"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/saltzmanjoelh/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.5.2")),
        .package(url: "https://github.com/saltzmanjoelh/aws-deploy-kit", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "example-lambda",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            exclude: ["payload.json"]
        ),
        .target(
            name: "Deploy",
            dependencies: [
                .product(name: "AWSDeployCore", package: "aws-deploy-kit"),
            ]),
        .testTarget(
            name: "BasicExampleTests",
            dependencies: [
                
            ]
        ),
    ]
)
