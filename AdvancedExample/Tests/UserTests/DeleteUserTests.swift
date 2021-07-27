import Foundation
import XCTest
@testable import Shared
@testable import User

final class DeleteUserTests: XCTestCase {
    
    func testDeleteUser() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.deleteMock = { (id: String) throws in
            // Don't throw, just return
        }
        let endpoint = DeleteUserEndpoint(dataStore: dataStore)
        
        let request: DeleteUserRequest = .init(id: UUID().uuidString)
        
        endpoint.handleRequest(nil, request) { (result: Result<Void, Error>) -> Void in
            do {
                try result.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    func testDeleteUserHandlesFailures() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        // The default action for delete() is to throw
        let endpoint = DeleteUserEndpoint(dataStore: dataStore)
        let request: DeleteUserRequest = .init(id: UUID().uuidString)

        endpoint.handleRequest(nil, request) { (result: Result<Void, Error>) -> Void in
            do {
                _ = try result.get()
                XCTFail("An error should have been thrown.")
            } catch {
                
            }
        }
    }
    
    static var allTests = [
        ("testDeleteUser", testDeleteUser),
        ("testDeleteUserHandlesFailures", testDeleteUserHandlesFailures),
    ]
}
