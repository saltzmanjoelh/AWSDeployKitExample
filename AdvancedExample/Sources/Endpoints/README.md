#  Endpoints

The code that will be executed in a Lambda to handle a request to a specific endpoint. We save synchronous calls to `Lambda.run` for the executables in the [Lambdas](Sources/Lambdas) group, explained next.

We keep the endpoint logic separate from the executable target. Then from the executable target we simply import the endpoint and run it in a synchonous Lambda closure.

