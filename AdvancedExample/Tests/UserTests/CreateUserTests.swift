import Foundation
import XCTest
@testable import Shared
@testable import User


final class CreateUserTests: XCTestCase {
    
    func testCreateUser() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.saveMock = { _ throws in
            // Don't throw, just return to simulate a success
        }
        UserEnvironment.shared.dataStore = dataStore
        let endpoint = try await CreateUserEndpoint(context: context.initContext)
        let request: CreateUserRequest = .init(id: User.fixture.id, name: User.fixture.name, email: User.fixture.email)
        
        let user = try await endpoint.handle(event: request, context: context.lambdaContext)
        
        XCTAssertEqual(user.email, request.email)
    }
    func testCreateUserHandlesFailures() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        UserEnvironment.shared.dataStore = dataStore
        // The default action for create() is to throw
        let endpoint = try await CreateUserEndpoint(context: context.initContext)
        let request: CreateUserRequest = .init(id: User.fixture.id, name: User.fixture.name, email: User.fixture.email)

        do {
            _ = try await endpoint.handle(event: request, context: context.lambdaContext)
            XCTFail("An error should have been thrown.")
        } catch {
            
        }
    }
    
    static var allTests = [
        ("testCreateUser", testCreateUser),
        ("testCreateUserHandlesFailures", testCreateUserHandlesFailures),
    ]
}
