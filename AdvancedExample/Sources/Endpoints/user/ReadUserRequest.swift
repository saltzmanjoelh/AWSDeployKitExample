//
//  ReadUserRequest.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

// A real read endpoint would have more options to search by.
// I'm only providing id for simplicity
public struct ReadUserRequest: Codable {
    public let id: String
    public init(id: String) {
        self.id = id
    }
    
    public func payload() throws -> String {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)!
    }
}
