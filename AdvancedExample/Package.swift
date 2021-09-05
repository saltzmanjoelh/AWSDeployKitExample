// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvancedExample",
    platforms: [
        .macOS(.v10_12)
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
        .package(url: "https://github.com/soto-project/soto", .branch("main")),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .branch("main")),
        .package(url: "https://github.com/saltzmanjoelh/aws-deploy-kit", .branch("main")),
        .package(url: "https://github.com/saltzmanjoelh/mocking", .branch("main")),
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
        .target(
            name: "User",
            dependencies: [
                "Shared",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Endpoints/user"
        ),
        // Lambdas which simply import their related library and run the endpoint
        .target(
            name: "create-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "Mocking", package: "mocking"),
            ],
            path: "./Sources/Lambdas/user/create"
        ),
        .target(
            name: "read-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Lambdas/user/read"
        ),
        .target(
            name: "delete-user",
            dependencies: [
                "Shared",
                "User",
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            ],
            path: "./Sources/Lambdas/user/delete"
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
        .target(
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
            path: "./Sources/Deployments/user"
        ),
            
    ]
)
