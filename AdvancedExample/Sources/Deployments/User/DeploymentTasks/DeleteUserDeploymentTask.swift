//
//  DeleteUserDeploymentTask.swift
//
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension DeleteUserRequest {
    /// After we update the Lambda, we want to test that it still works before setting the $LATEST to point to the new version.
    /// We use this payload to test the Lambda with and make sure that no errors are thrown
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}
class DeleteUserDeploymentTask: DeploymentTask {
    
    var functionName: String { DeleteUserEndpoint.functionName }

    func invocationSetUp(services: Servicable) -> EventLoopFuture<Void> {
        do {
            // You can use the services.lambda and invoke it directly. However, you have to convert the data to your result type.
            // You could instead use the existing CreateUserEndpoint if it has write access to the datastore.
            
            // We take advantage of the existing code to create a fixture so that when we try to delete it later, it's in the datastore.
            // We trust that the function works as expected since it's tested elsewhere.
            let createDeployment = CreateUserDeploymentTask()
            // We clear the tearDown because our test is to delete the User
            var invokeCreate = try createDeployment.createInvocationTask(services: services)
            invokeCreate.tearDown = nil
            
            // Execute the create function so that we have the User available to read.
            return invokeCreate
                .run(services: services) // We saved the tearDown for later
                .map({ _ in Void() })
        } catch {
            return services.lambda.eventLoopGroup.next().makeFailedFuture(error)
        }
    }
    func invocationPayload() throws -> String {
        return try DeleteUserRequest(id: User.fixture.id).payload()
    }
    func verifyInvocation(_ responseData: Data) throws -> Void {
        // We don't return anything from delete
        if responseData.count > 0,
           let response = String(data: responseData, encoding: .utf8) {
            throw InvocationError(description: "Expected to receive no response. Received: \(response)")
        }
    }
}
