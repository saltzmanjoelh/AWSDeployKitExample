//
//  DeleteUserEndpoint.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import AWSLambdaRuntime
import Foundation
import Shared

public struct DeleteUserEndpoint {
    public static let functionName = "delete-user"
    public let dataStore: Datastore<User>
    
    public init(dataStore: Datastore<User>)  {
        self.dataStore = dataStore
    }
    
    public func handleRequest(_ context: Lambda.Context?, _ request: DeleteUserRequest, _ callback: @escaping (Result<Void, Error>) -> Void) -> Void {
        do {
            try dataStore.delete(id: request.id)
            callback(.success(Void()))
        } catch {
            callback(.failure(error))
        }
    }

}
