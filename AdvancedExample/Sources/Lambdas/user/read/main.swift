 import Shared
 import User
 import Foundation
 import AWSLambdaRuntime
 
 let endpoint = ReadUserEndpoint(dataStore: Datastore<User>())
 Lambda.run(endpoint.handleRequest)
