//
//  CreateUserRequest.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

public struct CreateUserRequest: Codable {
    public let name: String
    public let email: String
    public init(name: String,
                email: String) {
        self.name = name
        self.email = email
    }
    
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}
