//
//  TableRepresentable.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation
import SotoDynamoDB

public protocol TableRepresentable: Codable {
    static var table: String { get set }
    var id: String { get }
}
