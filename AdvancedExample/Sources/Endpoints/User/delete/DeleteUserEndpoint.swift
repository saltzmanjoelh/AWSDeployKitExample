//
//  DeleteUserEndpoint.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

@available(macOS 12.0, *)
public struct DeleteUserEndpoint: LambdaHandler {
    public static let functionName = "delete-user"
    
    public typealias In = DeleteUserRequest
    public typealias Out = Void
    
    public init(context: Lambda.InitializationContext) async throws {
        
    }
    public func handle(event: In, context: Lambda.Context) async throws -> Out {
        try UserEnvironment.shared.dataStore.delete(id: event.id)
    }
}
