# AdvancedExample

An example of how to use [aws-deploy-kit](https://github.com/saltzmanjoelh/aws-deploy-kit) within an Xcode project to programmatically deploy Lambdas.

# TLDR
The path to this package directory (AdvancedExample) should be in the run args.

Switch your selected target in Xcode to `DeployUserEndpoints`.
Press `cmd` + `shift` + `<` to edit the scheme.
Add the path to this project in the "Arguments Passed On Launch" section `/path/to/AWSDeployKitExample/AdvancedExample`.
Make sure that Docker is running and hit run in Xcode.

## Step 1 - Create the endpoint logic (Endpoints)

The [Endpoints](Sources/Endpoints) contain logic to handle a request for a specific endpoint. We don't call `Lambda.main` in here. The [Lambdas](Sources/Lambdas) group is where we actually call `main()`, this will be explained next.

[CreateUserEndpoint](Sources/Endpoints/User/CreateUserEndpoint.swift): Endpoint logic for creating a user.

There are read and delete examples as well.

[CreateUserRequest](Sources/Endpoints/User/CreateUserRequest.swift): Describes the input that the [CreateUserEndpoint](Sources/Endpoints/User/CreateUserEndpoint.swift) expects.

### Shared

[Shared](Sources/Shared) Contains utilities that are endpoint agnostic like datastore clients and language extensions which are shared with all endpoint libraries. 
[Datastore](Sources/Shared/Datastore.swift): A super basic example of reading and writing to a datastore.

## Step 2 - Create the executable (Lambda)

Super simple functions that simply import an endpoint and run it in a Lambda.

[Create](Sources/Lambda/User/Create/main.swift): Simply imports the [CreateUserEndpoint](Sources/Endpoints/User/CreateUserEndpoint.swift) and runs it in a synchonous Lambda

[ Lambda (create-user) ]   ====>     [ Endpoint (CreateUserEndpoint) ]
[        main()        ]             [    handle(event:, context:)   ]

[AWSServices](Sources/Shared/AWSServices.swift): I like to group the services together. You'll find all the AWS services here.

## Step 3 - Deploy (Deployments)

Executables that programmatically deploy Lambdas. Take a look at [DeployUserEndpoints](Sources/Deployments/User/DeployUserEndpoints.swift) to see the steps involved. 

By implementing the the DeploymentTask protocol from [aws-deploy-kit](https://github.com/saltzmanjoelh/aws-deploy-kit), you are able to write code in Swift that helps test and deploy your endpoints.

Typically, we don't just simply deploy the Lambda. There are access policies that need to be implemented and such. Take a look at [AWSConfiguration](Sources/Deployments/User/AWSConfiguration) to an example of how to implement this.

After we update the Lambda, we want to test that it still works before setting the $LATEST to point to the new version. 

Please note the [Dockerfile](Dockerfile). You can customize your Docker container used for building with it. The only 2 requirements of your custom Dockerfile are that it has the correct Swift version for your package and that it contains the zip program. Zip is used to archive and upload your executable to AWS.

You may also include a .env file in the directory of your executable if you want it included with your Lambda. For example, Sources/Lambdas/User/Create/.env
