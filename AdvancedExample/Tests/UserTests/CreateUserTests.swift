import Foundation
import XCTest
@testable import Shared
@testable import User


final class CreateUserTests: XCTestCase {
    
    func testCreateUser() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.saveMock = { _ throws in
            // Don't throw, just return to simulate a success
        }
        let endpoint = CreateUserEndpoint(dataStore: dataStore)
        
        let request: CreateUserRequest = .init(name: "Johnny Appleseed", email: "Johnny@test.com")
        
        endpoint.handleRequest(nil, request) { (result: Result<User, Error>) -> Void in
            do {
                let value = try result.get()
                XCTAssertEqual(value.email, request.email)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    func testCreateUserHandlesFailures() throws {
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        // The default action for create() is to throw
        let endpoint = CreateUserEndpoint(dataStore: dataStore)
        let request: CreateUserRequest = .init(name: "Johnny Appleseed", email: "Johnny@test.com")

        endpoint.handleRequest(nil, request) { (result: Result<User, Error>) -> Void in
            do {
                _ = try result.get()
                XCTFail("An error should have been thrown.")
            } catch {
                
            }
        }
    }
    
    static var allTests = [
        ("testCreateUser", testCreateUser),
        ("testCreateUserHandlesFailures", testCreateUserHandlesFailures),
    ]
}
