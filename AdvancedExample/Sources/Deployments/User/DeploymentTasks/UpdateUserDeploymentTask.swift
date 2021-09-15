//
//  UpdateUserDeploymentTask.swift
//
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension UpdateUserRequest {
    /// After we update the Lambda, we want to test that it still works before setting the $LATEST to point to the new version.
    /// We use this payload to test the Lambda with and make sure that no errors are thrown
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}

class UpdateUserDeploymentTask: DeploymentTask {
    
    var functionName: String { UpdateUserEndpoint.functionName }
    
    var fixture = User.fixture
    var tearDown: EventLoopFuture<Void>!
    
    /// We want to test the Lamba by invoking it before we move it to the $LATEST version.
    func invocationSetUp(services: Servicable) -> EventLoopFuture<Void> {
        do {
            // You can use the services.lambda and invoke it directly. However, you have to convert the data to your result type.
            // You could instead use the existing CreateUserEndpoint if it has write access to the datastore.
            
            // We take advantage of the existing code to create a fixture so that when we try to update it later, it's in the datastore.
            // We trust that the function works as expected since it's tested elsewhere.
            let createDeployment = CreateUserDeploymentTask()
            // We save the tearDown for later in the invocationTearDown step.
            // This will delete the User that we are creating for the test.
            tearDown = createDeployment.invocationTearDown(services: services)
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
        return try UpdateUserRequest(id: fixture.id, name: "UPDATED_NAME", email: "UPDATED_EMAIL").payload()
    }
    func verifyInvocation(_ responseData: Data) throws -> Void {
        let response = try JSONDecoder().decode(User.self, from: responseData)
        if response.name != fixture.name {
            throw InvocationError(description: "Invalid name. Received: \(response.name). Expected: \(fixture.name)")
        }
        if response.email != fixture.email {
            throw InvocationError(description: "Invalid email. Received: \(response.email). Expected: \(fixture.email)")
        }
    }
    func invocationTearDown(services: Servicable) -> EventLoopFuture<Void> {
        return tearDown
    }
}
