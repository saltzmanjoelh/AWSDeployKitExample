//
//  MockDatastore.swift
//  
//
//  Created by Joel Saltzman on 7/15/21.
//

import Foundation
import Shared
import Mocking

/// We subclass the DataStore so that we can customize what the results are with mocks.
/// We don't need to actually save anything. We just want certain results.
class MockDatastore<T: TableRepresentable>: Datastore<T> {
    
    override open func save(_ entry: T) throws {
        // We simply call the saveMock, which the default action is to throw.
        // We want to specify our results
        try saveMock(entry)
    }
    @ThrowingMock
    public var saveMock = { (entry: T) in throw DatastoreError.failure }
    
    override open func read(id: String) throws -> T {
        try readMock(id)
    }
    @ThrowingMock
    var readMock = { (id: String) throws -> T in
        throw DatastoreError.failure
    }
    
    override open func delete(id: String) throws {
        try deleteMock(id)
    }
    @ThrowingMock
    var deleteMock = { (id: String) throws in
        throw DatastoreError.failure
    }
}
