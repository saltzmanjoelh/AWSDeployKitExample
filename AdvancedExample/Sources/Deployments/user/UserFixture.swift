//
//  Fixture.swift
//  
//
//  Created by Joel Saltzman on 7/15/21.
//

import Foundation
import Shared
import User

extension User {
    public static func fixture() -> User {
        return User.init(id: "1",
                         name: "Johnny Appleseed",
                         email: "johnny@test.com",
                         createdAt: Date.init(timeIntervalSince1970: 100000))
    }
}
