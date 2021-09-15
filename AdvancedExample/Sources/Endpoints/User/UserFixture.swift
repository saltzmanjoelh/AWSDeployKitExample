//
//  Fixture.swift
//  
//
//  Created by Joel Saltzman on 7/15/21.
//

import Foundation

#if DEBUG && os(macOS)
extension User {
    public static var fixture: User = {
        return User.init(id: "1",
                         name: "Johnny Appleseed",
                         email: "johnny@test.com",
                         createdAt: Date.init(timeIntervalSince1970: 100000))
    }()
}
#endif
