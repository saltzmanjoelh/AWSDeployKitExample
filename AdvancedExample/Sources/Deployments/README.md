#  Deployments

Executables that programmatically deploy endpoints.

## Deployment Executable

### DeployUserEndpoints.swift

A `ParsableCommand` to run all of the deployments. It creates the `users` table in Dynamo, makes sure that role exists for each Lambda and that it has access to Dynamo.

## Deployment Tasks

We have several Lambdas that we want to deploy:

* create-user
* read-user
* updated-user
* delete-user

The executables for each Lambda simply run their Endpoint related LambdaHandler. For example, the create-user executable simply imports the CreateUserEndpoint and call's it's main function.

To deploy the Lambda, we create a `DeploymentTask`. For the create-user Lambda, we have a [CreateUserDeploymentTask](Sources/Deployments/user/CreateUserDeploymentTask.swift) which implements the [DeploymentTask]() protocol.
