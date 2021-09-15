//
//  UpdateUserRequest.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

@available(macOS 12.0, *)
public struct UpdateUserRequest: Codable {
    public let id: String
    
    public let name: String?
    public let email: String?
    
    public init(id: String, name: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
    }
}
