//
//  User.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation
import Shared
import SotoDynamoDB

public struct User: TableRepresentable, Codable {
    // Would normally be "users" but added the prefix to not collide with any tables that you might already have.
    public static var table: String = "aws-deploy-kit-example-users"
    
    public let id: String
    public let name: String
    public let email: String
    public let createdAt: Date
    public init(id: String,
                name: String,
                email: String,
                createdAt: Date = .init()) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }

}
