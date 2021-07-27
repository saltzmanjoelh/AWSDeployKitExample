//
//  ReadUserEndpoint.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared


public struct ReadUserEndpoint {
    public static let functionName = "read-user"
    public let dataStore: Datastore<User>
    
    public init(dataStore: Datastore<User>)  {
        self.dataStore = dataStore
    }
    
    public func handleRequest(_ context: Lambda.Context?, _ request: ReadUserRequest, _ callback: @escaping (Result<User, Error>) -> Void) -> Void {
        do {
            let user = try dataStore.read(id: request.id)
            callback(.success(user))
        } catch {
            callback(.failure(error))
        }
    }

}
