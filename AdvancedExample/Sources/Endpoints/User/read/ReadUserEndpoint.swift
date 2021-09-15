//
//  ReadUserEndpoint.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

@available(macOS 12.0, *)
public struct ReadUserEndpoint: LambdaHandler {
    
    public static let functionName = "read-user"
    
    public typealias In = ReadUserRequest
    public typealias Out = User
    
    public init(context: Lambda.InitializationContext) async throws {
        
    }
    public func handle(event: In, context: Lambda.Context) async throws -> Out {
        let user = try UserEnvironment.shared.dataStore.read(id: event.id)
        return user
    }

}
