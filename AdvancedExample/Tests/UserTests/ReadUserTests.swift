import Foundation
import XCTest
@testable import Shared
@testable import User

final class ReadUserTests: XCTestCase {
    
    func testReadUser() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.readMock = { (id: String) throws -> User in
            // Don't throw, return a user
            return User(id: id, name: UUID().uuidString, email: UUID().uuidString)
        }
        let endpoint = ReadUserEndpoint(dataStore: dataStore)
        
        let request: ReadUserRequest = .init(id: UUID().uuidString)
        
        endpoint.handleRequest(nil, request) { (result: Result<User, Error>) -> Void in
            do {
                let value = try result.get()
                XCTAssertEqual(value.id, request.id)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    func testReadUserHandlesFailures() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        // The default action for read() is to throw
        let endpoint = ReadUserEndpoint(dataStore: dataStore)
        let request: ReadUserRequest = .init(id: UUID().uuidString)

        endpoint.handleRequest(nil, request) { (result: Result<User, Error>) -> Void in
            do {
                _ = try result.get()
                XCTFail("An error should have been thrown.")
            } catch {
                
            }
        }
    }
    
    static var allTests = [
        ("testReadUser", testReadUser),
        ("testReadUserHandlesFailures", testReadUserHandlesFailures),
    ]
}
