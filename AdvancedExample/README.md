# Advanced

An example of how to use [aws-deploy-kit](https://github.com/saltzmanjoelh/aws-deploy-kit) within an Xcode project to programmatically deploy Lambdas.

## Shared

Utilities that are endpoint agnostic like datastore clients and language extensions.

[AWSServices](Sources/Shared/AWSServices.swift): I like to group the services together. You'll find all the AWS services here.

[Datastore](Sources/Shared/Datastore.swift): A super basic example of reading and writing to a datastore.

## Endpoints

The code that will be executed in a Lambda to handle a request to a specific endpoint. We save synchronous calls to `Lambda.run` for the executables in the [Lambdas](Sources/Lambdas) group, explained next.

We keep the endpoint logic separate from the executable target. Then from the executable target we simply import the endpoint and runs it in a synchonous Lambda closure: `Lambda.run(endpoint.handleRequest)`.

[CreateUserRequest](Sources/Endpoints/user/CreateUserRequest.swift): Describes the input that the [CreateUserEndpoint](Sources/Endpoints/user/CreateUserEndpoint.swift) expects. 

[CreateUserEndpoint](Sources/Endpoints/user/CreateUserEndpoint.swift): Endpoint logic for creating a user.

There are read and delete examples as well.

## Lambda

Super simple functions that simply import an endpoint and run it in a Lambda.

[create](Sources/Lambda/user/create/main.swift): Simply imports the [CreateUserEndpoint](Sources/Endpoints/user/CreateUserEndpoint.swift) and runs it in a synchonous Lambda

## Deployments

Executables that programmatically deploy endpoints.

