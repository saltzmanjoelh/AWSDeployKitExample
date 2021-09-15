//
//  DeployUserEndpoints.swift
//  
//
//  Created by Joel Saltzman on 9/8/21.
//

import Foundation
import Shared
import User
import AWSDeployCore
import ArgumentParser

struct DeployUserEndpoints: ParsableCommand {

    static let directoryHelp = """
    The path to this package directory (AdvancedExample) should be in the run args.
    
    Switch your selected target in Xcode to `DeployUserEndpoints`.
    Press `cmd` + `shift` + `<` to edit the scheme.
    Add the path to this project in the "Arguments Passed On Launch" section `/path/to/AWSDeployKitExample/AdvancedExample`.
    Make sure that Docker is running and hit run in Xcode.
    """
    
    @Argument(help: "\(Self.directoryHelp)")
    var directory: String
    
    public mutating func run() throws {

        // Parse the path to the package
        let packageDirectory = URL(fileURLWithPath: directory)
        
        // Make your list of tasks to perform
        let tasks: [DeploymentTask] = [
            CreateUserDeploymentTask(),
//            ReadUserDeploymentTask(),
//            UpdateUserDeploymentTask(),
//            DeleteUserDeploymentTask()
        ]
        
        // Make sure that the table exists first.
        // You could do table migrations if you are using an SQL store.
        let config = AWSConfiguration()
        do {
            try config.verifyDynamoTable()
            // Make sure that each Lambda execution role has access to DynamoDB
            try tasks.forEach({
                try config.verifyRoleAccess(for: $0.functionName )
            })
        } catch {
            // It's ok to not have the Lambda available yet. We will create it in deploy()
            guard "\(error)".contains("Function not found") else {
                throw error
            }
        }
        
        
        // Deploy
        let results = try tasks.deploy(from: packageDirectory, services: Services.shared).wait()
        print("Done! \(results)")
    }
}

