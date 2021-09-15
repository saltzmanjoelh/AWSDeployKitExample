// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvancedExample",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Utilities
        .library(name: "Shared",
                 targets: ["Shared"]),
        // Endpoint functions
        .library(name: "User",
                 targets: ["User"]),
        // Lambda executables
        .executable(
            name: "create-user",
            targets: ["create-user"]
        ),
        .executable(
            name: "read-user",
            targets: ["read-user"]
        ),
        .executable(
            name: "update-user",
            targets: ["update-user"]
        ),
        .executable(
            name: "delete-user",
            targets: ["delete-user"]
        ),
        // Deploy
        .executable(
            name: "DeployUserEndpoints",
            targets: ["DeployUserEndpoints"]
        ),
        
    ],
    dependencies: [
        .package(url: "https://github.com/soto-project/soto", .upToNextMajor(from: "5.8.1")),
        .package(url: "https://github.com/saltzmanjoelh/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.5.2")),
        .package(url: "https://github.com/saltzmanjoelh/aws-deploy-kit", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/saltzmanjoelh/mocking", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Utilities to share amoung the endpoints like database clients or language extensions
        .target(
            name: "Shared",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "SotoIAM", package: "soto"),
                .product(name: "SotoLambda", package: "soto"),
                .product(name: "SotoSTS", package: "soto"),
            ],
            exclude: ["README.md"]
        ),
        // The suite of User endpoints. We give each model and it's related endpoint functions
        // it's own library so that we can share it with other libraries.
        // For example, a Authentication library could import the User library.
        .target(
            name: "User",
            dependencies: [
                "Shared",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Endpoints/User"
        ),
        // Lambdas which simply import their related library and run the endpoint
        .executableTarget(
            name: "create-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "Mocking", package: "mocking"),
            ],
            path: "./Sources/Lambdas/User/Create"
        ),
        .executableTarget(
            name: "read-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Lambdas/User/Read"
        ),
        .executableTarget(
            name: "update-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Lambdas/User/Update"
        ),
        .executableTarget(
            name: "delete-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Lambdas/User/Delete"
        ),
        // Test the suite of endpoints
        .testTarget(
            name: "UserTests",
            dependencies: [
                "Shared",
                "User",
                .product(name: "Mocking", package: "mocking"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "SotoIAM", package: "soto"),
                .product(name: "SotoLambda", package: "soto"),
                .product(name: "SotoSTS", package: "soto"),
            ]
        ),
        // Deploy a specific suite of endpoints
        .executableTarget(
            name: "DeployUserEndpoints",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSDeployCore", package: "aws-deploy-kit"),
                .product(name: "Mocking", package: "mocking"),
                .product(name: "SotoSTS", package: "soto"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "SotoIAM", package: "soto"),
            ],
            path: "./Sources/Deployments/User"
        ),
            
    ]
)
