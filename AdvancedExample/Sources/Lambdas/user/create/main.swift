 import Shared
 import User
 import Foundation
 import AWSLambdaRuntime
 
 let endpoint = CreateUserEndpoint(dataStore: Datastore<User>())
 Lambda.run(endpoint.handleRequest)
