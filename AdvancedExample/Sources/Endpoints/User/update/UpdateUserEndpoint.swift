//
//  UpdateUserEndpoint.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

@available(macOS 12.0, *)
public struct UpdateUserEndpoint: LambdaHandler {
    
    public static let functionName = "update-user"
    
    public typealias In = UpdateUserRequest
    public typealias Out = User
    
    public init(context: Lambda.InitializationContext) async throws {
        
    }
    public func handle(event: In, context: Lambda.Context) async throws -> Out {
        // In a real app, I would use UpdateItem with specific fields but
        // I'm trying to keep it simple for this example.
        let existingUser = try UserEnvironment.shared.dataStore.read(id: event.id)
        let updatedUser = User(id: event.id,
                               name: event.name ?? existingUser.name,
                               email: event.email ?? existingUser.email)
        try UserEnvironment.shared.dataStore.save(updatedUser)
        
        return updatedUser
    }

}
