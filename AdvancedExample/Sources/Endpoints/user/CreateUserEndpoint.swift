//
//  CreateUserEndpoint.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

public struct CreateUserEndpoint {

    public static var functionName = "create-user"
    public let dataStore: Datastore<User>
    
    public init(dataStore: Datastore<User>)  {
        self.dataStore = dataStore
    }
    
    public func handleRequest(_ context: Lambda.Context?, _ request: CreateUserRequest, _ callback: @escaping (Result<User, Error>) -> Void) -> Void {
        // Authorization is done before this function is reached.
        // Create the user in the datastore
        do {
            let user = User(id: UUID().uuidString,
                            name: request.name,
                            email: request.email)
            try dataStore.save(user)
            callback(.success(user))
        } catch {
            callback(.failure(error))
        }
    }

}
