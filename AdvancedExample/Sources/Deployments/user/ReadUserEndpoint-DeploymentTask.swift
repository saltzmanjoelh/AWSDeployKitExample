//
//  ReadUserEndpoint-DeploymentTask.swift
//  
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension ReadUserEndpoint {
    class Deployment: DeploymentTask {
        
        var functionName: String { ReadUserEndpoint.functionName }
        
        var fixture = User.fixture()
        var tearDown: EventLoopFuture<Void>!

        func invocationSetUp(services: Servicable) -> EventLoopFuture<Void> {
            do {
                // You can use the services.lambda and invoke it directly. However, you have to convert the data to your result type.
                // You could instead use the CreateUserEndpoint if it has write access to the datastore.
                
                // We take advantage of the existing code to create a fixture so that when we try to read it later, it's in the datastore.
                // We trust that the function works as expected since is tested elsewhere.
                let createDeployment = CreateUserEndpoint.Deployment()
                // We save the tearDown for later
                tearDown = createDeployment.invocationTearDown(services: services)
                return try createDeployment
                    .createInvocationTask(services: services)
                    .run(skipTearDown: true, services: services) // We saved the tearDown for later
                    .map({ _ in Void() })
            } catch {
                return services.lambda.eventLoopGroup.next().makeFailedFuture(error)
            }
        }
        func invocationPayload() throws -> String {
            return try ReadUserRequest(id: fixture.id).payload()
        }
        func verifyInvocation(_ responseData: Data) -> Bool {
            do {
                let response = try JSONDecoder().decode(User.self, from: responseData)
                return response.name == fixture.name &&
                    response.email == fixture.email
            } catch {
                return false
            }
        }
        func invocationTearDown(services: Servicable) -> EventLoopFuture<Void> {
            return tearDown
        }
    }
    
}
