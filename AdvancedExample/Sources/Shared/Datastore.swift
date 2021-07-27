//
//  DataStore.swift
//  
//
//  Created by Joel Saltzman on 7/9/21.
//

import Foundation
import SotoDynamoDB


public enum DatastoreError: Error {
    case failure
    case notFound
    case readError(String)
    
    var description: String {
        switch self {
        case .failure:
            return "Failed to perform Datastore Action"
        case .notFound:
            return "Entry was not found in Datastore"
        case .readError(let key):
            return "Failed to read model. Missing key: \"\(key)\""
        }
    }
}

// Really basic interface to saving in a datastore like DynamoDB
open class Datastore<T: TableRepresentable> {
    
    public init() { }
    
    open func read(id: String) throws -> T {
        let input = DynamoDB.GetItemInput(key: ["id": .s(id)], tableName: T.table)
        let output = try AWSServices.shared.dynamoDB.getItem(input).wait()
        guard let attributes = output.item else { throw DatastoreError.notFound }
        return try DynamoDBDecoder().decode(T.self, from: attributes)
    }
    open func save(_ entry: T) throws {
        let input = DynamoDB.PutItemCodableInput(item: entry, tableName: T.table)
        _ = try AWSServices.shared.dynamoDB.putItem(input).wait()
    }
    open func delete(id: String) throws {
        let input = DynamoDB.DeleteItemInput(key: ["id": .s(id)], tableName: T.table)
        _ = try AWSServices.shared.dynamoDB.deleteItem(input).wait()
    }
}
