//
//  DeleteUserMessages.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

public struct DeleteUserRequest: Codable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}
