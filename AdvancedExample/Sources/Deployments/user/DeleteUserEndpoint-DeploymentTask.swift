//
//  DeleteUserEndpoint-DeploymentTask.swift
//
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension DeleteUserEndpoint {
    class Deployment: DeploymentTask {
        
        var functionName: String { DeleteUserEndpoint.functionName }
        
        var fixture = User.fixture()
        var tearDown: EventLoopFuture<Void>!

        func invocationSetUp(services: Servicable) -> EventLoopFuture<Void> {
            do {
                // Create the user
                let createDeployment = CreateUserEndpoint.Deployment()
                return try createDeployment
                    .createInvocationTask(services: services)
                    .run(skipTearDown: true, services: services) // Skipping tearDown, this should delete the fixture
                    .map({ _ in Void() })
            } catch {
                return services.lambda.eventLoopGroup.next().makeFailedFuture(error)
            }
        }
        func invocationPayload() throws -> String {
            return try DeleteUserRequest(id: fixture.id).payload()
        }
        func verifyInvocation(_ responseData: Data) -> Bool {
            // We don't return anything from delete
            return responseData.count == 0
        }
        func invocationTearDown(services: Servicable) -> EventLoopFuture<Void> {
            return tearDown
        }
    }
    
}
