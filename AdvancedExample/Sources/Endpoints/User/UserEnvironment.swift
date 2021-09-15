//
//  UserEnvironment.swift
//  User
//
//  Created by Joel Saltzman on 9/8/21.
//

import Foundation
import Shared

public struct UserEnvironment {
    
    public static var shared = UserEnvironment()
    
    public var dataStore = Datastore<User>()
}
