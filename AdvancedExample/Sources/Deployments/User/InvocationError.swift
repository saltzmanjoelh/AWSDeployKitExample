//
//  InvocationError.swift
//
//
//  Created by Joel Saltzman on 9/12/21.
//

import Foundation

class InvocationError: Error, CustomStringConvertible {
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
