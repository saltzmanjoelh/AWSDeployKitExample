 import AWSLambdaRuntime
 import Shared
 import User
 import Foundation
 
 // Being in the global space, this will remain between invocations
// let dataStore = try DataStore<UsersCreateRequest>()
// 
// Lambda.run { (context, request: UsersCreateRequest, callback: @escaping (Result<UsersCreateResponse, Error>) -> Void) in
//    
//    // Authorization is done before this function is reached.
//    // Create the user in the datastore
//    do {
//        try dataStore.create(request)
//        let response = UsersCreateResponse.init(id: request.id,
//                                                name: request.name,
//                                                email: request.email,
//                                                createdAt: .init())
//        callback(.success(response))
//    } catch {
//        callback(.failure(error))
//    }
// }
