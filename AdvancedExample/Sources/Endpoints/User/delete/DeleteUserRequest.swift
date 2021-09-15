//
//  DeleteUserRequest.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

@available(macOS 12.0, *)
public struct DeleteUserRequest: Codable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}
