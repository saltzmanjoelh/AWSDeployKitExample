//
//  CreateUserDeploymentTask.swift
//  
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension CreateUserRequest {
    /// After we update the Lambda, we want to test that it still works before setting the $LATEST to point to the new version.
    /// We use this payload to test the Lambda with and make sure that no errors are thrown
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}

public class CreateUserDeploymentTask: DeploymentTask {
    public var functionName: String { CreateUserEndpoint.functionName }
    
    public var fixture = User.fixture
    
    public func invocationPayload() throws -> String {
        return try CreateUserRequest(id: fixture.id, name: fixture.name, email: fixture.email).payload()
    }

    public func verifyInvocation(_ responseData: Data) throws -> Void {
        // Does the response match the fixture?
        let response = try JSONDecoder().decode(User.self, from: responseData)
        
        // The fixure's id was random, we only sent the name and email. A new id should be returned.
        if response.id != fixture.id {
            throw InvocationError(description: "Invalid id. Received: \(response.id). Expected: \(fixture.id)")
        }
        if response.name != fixture.name {
            throw InvocationError(description: "Invalid name. Received: \(response.name). Expected: \(fixture.name)")
        }
        if response.email != fixture.email {
            throw InvocationError(description: "Invalid email. Received: \(response.email). Expected: \(fixture.email)")
        }
    }
    
    public func invocationTearDown(services: Servicable) -> EventLoopFuture<Void> {
        do {
            // Delete the fixture user by invoking the delete-user function
            // We skip setUp and tearDown because we want to simply invoke the delete with our fixture's id
            let deleteDeployment = DeleteUserDeploymentTask()
            let invokeDelete = InvocationTask.init(functionName: deleteDeployment.functionName,
                                                       payload: try deleteDeployment.invocationPayload(),
                                                       verifyResponse: { data in
                if data.count > 0,
                   let response = String(data: data, encoding: .utf8){
                    throw InvocationError(description: "Error in invocationTearDown. Delete failed with response: \(response)")
                }
            })
            return invokeDelete
                .run(services: services)
                .map({ _ in Void() })
        } catch {
            return services.lambda.eventLoopGroup.next().makeFailedFuture(error)
        }
    }
}
