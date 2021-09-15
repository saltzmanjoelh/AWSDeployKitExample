//
//  CreateUserEndpoint.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

@available(macOS 12.0, *)
public struct CreateUserEndpoint: LambdaHandler {
    public static var functionName = "create-user"
    
    public typealias In = CreateUserRequest
    public typealias Out = User
    
    public init(context: Lambda.InitializationContext) async throws {
        
    }
    public func handle(event: In, context: Lambda.Context) async throws -> Out {
        // Create the user in the datastore
        let user = User(id: event.id,
                        name: event.name,
                        email: event.email)
        try UserEnvironment.shared.dataStore.save(user)
        return user
    }

}
