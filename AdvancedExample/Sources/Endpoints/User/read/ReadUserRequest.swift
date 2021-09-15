//
//  ReadUserRequest.swift
//
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation

// A real read endpoint would have more options to search by.
// I'm only providing id for simplicity
@available(macOS 12.0, *)
public struct ReadUserRequest: Codable {
    public let id: String
    public init(id: String) {
        self.id = id
    }
}
