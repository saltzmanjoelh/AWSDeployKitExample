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
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/saltzmanjoelh/AWSDeployKit", .branch("main")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "example-lambda",
            dependencies: []),
        .target(
            name: "Deploy",
            dependencies: [
                .product(name: "AWSDeployCore", package: "AWSDeployKit")
            ]),
    ]
)
