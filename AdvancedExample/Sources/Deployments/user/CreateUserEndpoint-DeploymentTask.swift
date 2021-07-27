//
//  CreateUserEndpoint-DeploymentTask.swift
//  
//
//  Created by Joel Saltzman on 7/10/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import NIO

extension CreateUserEndpoint {
    public class Deployment: DeploymentTask {
        public var functionName: String { CreateUserEndpoint.functionName }
        
        public var fixture = User.fixture()
        
        public func invocationPayload() throws -> String {
            return try CreateUserRequest(name: fixture.name, email: fixture.email).payload()
        }

        public func verifyInvocation(_ responseData: Data) -> Bool {
            // Does the response match the fixture?
            do {
                let response = try JSONDecoder().decode(User.self, from: responseData)
                return response.name == fixture.name &&
                    response.email == fixture.email &&
                    response.id != fixture.id // The fixure's id was random, we only sent the name and email. A new id should be returned.
            } catch {
                return false
            }
        }
        
//        public func invocationTearDown(services: Servicable) -> EventLoopFuture<Void> {
//            do {
//                return DeleteUserEndpoint().run()
//            } catch {
//                return services.lambda.eventLoopGroup.next().makeFailedFuture(error)
//            }
//        }
    }
    
}
