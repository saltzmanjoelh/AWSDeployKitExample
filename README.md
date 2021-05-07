# AWSDeployKitExample

An example of how to use [AWSDeployKit](https://github.com/saltzmanjoelh/AWSDeployKit) within an Xcode project.

## TLDR

Take a look at the `Deploy` target and the "Arguments Passed on Launch" in the scheme by pressing cmd + shift + < and selecting the the `Deploy` target. 
## Setup
Here are the detailed steps to setup a project like this.

### Create Your Package

Create a new directory called `example-lambda`.
`cd` into it.
Create a new Swift package.
Add a directory for the `Deploy` source code and create it's `main.swift` file.
Open the project.

```shell
mkdir example-lambda
cd example-lambda
swift package init --type executable
mkdir Sources/Deploy
touch Sources/Deploy/main.swift
open Package.swift
```

### Lambda Target

At the top of the Package.swift manifest, create the executable product that will be used for the Lambda function. We are calling it `example-lambda`. The products section was not created for us, do that now.

```swift

products: [
    .executable(
        name: "example-lambda",
        targets: ["example-lambda"]
    ),
],
```

Add the Swift AWS Lambda related dependencies

```swift
dependencies: [
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .branch("main")),
    .package(url: "https://github.com/apple/swift-nio", .branch("main")),
    .package(url: "https://github.com/apple/swift-log", .branch("main")),
],
```

Update the `example-lambda` target at the bottom with the Swift AWS Lambda related dependencies

```swift
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
]
```

### Deployment Target

The `Deploy` target is the main point of this example project. Add `AWSDeployKit` as a dependency. The dependencies section should now contain all these packages:

```swift
dependencies: [
    // Existing
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .branch("main")),
    .package(url: "https://github.com/apple/swift-nio", .branch("main")),
    .package(url: "https://github.com/apple/swift-log", .branch("main")),
    // Add this one
    .package(url: "https://github.com/saltzmanjoelh/AWSDeployKit", .branch("main")),
],
```

The final setup of setting up the package manifest is to add the `Deploy` target. It doesn't need an entry in the products section. The targets section should now look like this:

```swift
targets: [
    // Existing
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
    // Add this one
    .target(
        name: "Deploy",
        dependencies: [
            .product(name: "AWSDeployCore", package: "AWSDeployKit"),
        ]),
]
```

Your package manifest is done. It should look like the [Package.swift](Package.swift) manifest that was provided in this repo. 

### Launch Arguments

Set your selected target to `Deploy`. Press cmd + shift + < to edit the schem and switch to the Arguments tab. The minimum arguments you should specify are in this case should be `-d /path/to/project` and `-s Deploy`. The `-d` flag tells the `Deploy` app where to find the project to bulid. The `-s` flag tells the `Deploy` app to skip building the Deploy target. We don't need it to build itself. In this example, we are providing a `-p` flag to publish the built `example-lambda`.

[LaunchArguments](LaunchArguments.png)

## AWS Lambda Setup

Currently, `AWSDeployKit` only supports updating the Lambda. You should log into your AWS account and create a new Lambda called `example-lambda`. For the runtime, you should set it as "Provide your own bootstrap on Amazon Linux 2". 

[LambdaSetup](LambdaSetup.png)

## example-lambda Setup

Let's add some minimal code to our Lamdba function. Replace the entire contents of `Sources/example-lambda/main.swift` with this:

```swift

 import AWSLambdaRuntime
 
 private struct Request: Codable {
    let name: String
 }
 private struct Response: Codable {
    let message: String
 }
 
 Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
    callback(.success(Response(message: "Hello, \(request.name)")))
 }
 ```

 ## Deploy Source Code
 
 It doesn't take much to make the `Deploy` code. The `Sources/Deploy/main.swift` file should be empyt. Simply paste this in there:

 ```swift
import Foundation
import AWSDeployCore

AppDeployer.main()
```


## Build and Deploy

With the `Deploy` target selected, run it! You should see the Xcode console start building and deploying. 


## Test

You can invoke your newly updated Lambda

```shell
aws lambda invoke --function-name example-lambda \
  --cli-binary-format raw-in-base64-out \
  --payload '{ "name": "Bob" }' \
  output.txt
cat output.txt
```

